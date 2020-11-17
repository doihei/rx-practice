//
//  APIKit+.swift
//  young-jump-ios-datasource
//
//  Created by doi on 2019/09/10.
//

import APIKit
import RxSwift
import SwiftyBeaver
import SwiftyUserDefaults

extension Session {
    
    /// リクエスト送信(Rx)
    ///
    /// - Parameter request: Requestable
    /// - Returns: Observable<Requestable.Response>
    func send<T: Requestable>(_ request: T) -> Observable<T.Response> {
        return Single.create { [weak self] observer -> Disposable in
            guard let self = self else {
                // 来ることは理論上ないけど念の為、エラー流し
                observer(.error(DatasourceErrorData(DatasourceError.undefined, requestRetryType: request.retryType)))
                return Disposables.create()
            }
            SwiftyBeaver.debug(request)
            if request.isMock, let mockResponse = request.mockResponse {
                observer(.success(mockResponse))
            } else {
                self.send(request) { result in
                    switch result {
                    case .success(let response):
                        observer(.success(response))
                    case .failure(let error):
                        SwiftyBeaver.error(error)
                        switch error {
                        case .connectionError(let connectionError as NSError):
                            let apiErrorData: DatasourceErrorData
                            switch connectionError.code {
                            case -1001, -1009:
                                // when timeout
                                apiErrorData = DatasourceErrorData(DatasourceError.requestTimeout, requestRetryType: request.retryType)
                            default:
                                apiErrorData = DatasourceErrorData(DatasourceError.internal(connectionError.localizedDescription), requestRetryType: request.retryType)
                            }
                            observer(.error(apiErrorData))
                        case .requestError(let error), .responseError(let error):
                            observer(.error(error))
                        @unknown default:
                            observer(.error(DatasourceErrorData(DatasourceError.undefined, requestRetryType: request.retryType)))
                        }
                    }
                }
                
            }
            return Disposables.create()
        }
            .asObservable()
            .catchError { [weak self] error -> Observable<T.Response> in
                guard let self = self else {
                    return .error(error)
                }
                return self.handleError(session: request, error: error)
            }
    }
    
    /// データ層のエラーハンドリング
    /// - Parameters:
    ///   - request: 対象リクエスト
    ///   - error: エラー
    private func handleError<T: Requestable>(session request: T, error: Error) -> Observable<T.Response> {
        switch (error as? DatasourceErrorData)?.datasourceError as? APIError {
        case .notFoundSessionAtRedis?:
            // セッションのリフレッシュ対象のエラーはリフレッシュする
            // cf: https://and-factory.atlassian.net/wiki/spaces/yanjan/pages/290357475
            return request.isAuthenticate ? reflesh(session: request) : .error(error)
        case .onApplication?:
            // カモフラ環境に切り替え
            // cf: https://and-factory.atlassian.net/wiki/spaces/yanjan/pages/290652215
            return changeCamoflage(session: request)
        default:
            return .error(error)
        }
    }
    
    /// セッションリフレッシュ
    /// - Parameters:
    ///   - request: リフレッシュ対象のリクエスト
    ///   - isChangeCamoflage: カモフラ環境に切り替えたかどうか
    private func reflesh<T: Requestable>(session request: T, isChangeCamouflage: Bool = false) -> Observable<T.Response> {
        if !isChangeCamouflage {
            // カモフラフラグはオフに切り替える
            UserDefaultsGatewayProvider.provide().set(DefaultsKeys.isCamouflage, false)
        }
        return self.send(PostLoginRequest())
            .flatMap { [weak self] response -> Observable<T.Response> in
                guard let self = self else {
                    return .error(DatasourceError.undefined)
                }
                // リフレッシュ保持
                let storage = RealmGatewayProvider.provide()
                try? storage.update(
                    AuthObject(
                        accessToken: response.accessToken,
                        key: response.sharedSecurityKey,
                        userId: Int(response.loginMember.id),
                        sex: Int(response.loginMember.sex),
                        age: Int(response.loginMember.age)
                    )
                )
                return self.send(request)
            }
    }
    
    /// カモフラ環境に切り替える
    /// - Parameter request: 対象のリクエスト
    private func changeCamoflage<T: Requestable>(session request: T) -> Observable<T.Response> {
        // カモフラフラグをONに切り替える
        UserDefaultsGatewayProvider.provide().set(DefaultsKeys.isCamouflage, true)
        // 認証ありの場合はリフレッシュからやり直し
        // それ以外はカモフラフラグOnにして再通信のみ
        return request.isAuthenticate ? reflesh(session: request, isChangeCamouflage: true) : send(request)
    }
}
