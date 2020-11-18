//
//  Action+.swift
//  young-jump-ios
//
//  Created by doi on 2019/10/09.
//

import Action
import RxCocoa
import RxSwift

extension Action {
    
    /// Outputとエラーを合成したresult
    var result: Observable<Result<Element, ActionError>> {
        return .create { [weak self] observable -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            return Disposables.create(
                self.elements
                    .map { .success($0) }
                    .bind(to: observable),
                self.errors
                    .map { .failure($0) }
                    .bind(to: observable)
            )
        }
    }
    
    /// 正常系
    var normalState: Observable<NetworkState> {
        return .merge(
            // executing中は .loadingを流す
            executing
                .filter { $0 }
                .map { _ in
                    NetworkState.loading
                },
            // elementsは.normalに切り替えてあとは流さない
            elements
                .flatMap { _ -> Observable<NetworkState> in
                    .just(NetworkState.normal)
                }
        )
    }
    
    /// bindするネットワーク状態
    var state: Observable<NetworkState> {
        return .merge(
            normalState,
            /// エラーはリトライ判定しつつ、エラーで流す
            underlyingError
                .flatMap { error -> Observable<NetworkState> in
                    .just(.error(error: error))
                }
        )
    }
}
