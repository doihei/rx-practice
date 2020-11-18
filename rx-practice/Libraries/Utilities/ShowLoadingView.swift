//
//  ShowLoadingView.swift
//  young-jump-ios
//
//  Created by doi on 2019/11/22.
//

import Action
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol ShowLoadingView: ShowAlertView {
    
    func updateNetworkState(_ networkState: NetworkState,
                            errorActionHandler: (() -> Void)?,
                            force: ((NetworkState) -> Bool)?)
}

// MARK: - Reactive network state
extension Reactive where Base: UIViewController & ShowLoadingView {
    
    var networkState: Binder<NetworkState> {
        return .init(base) { vc, state in
            vc.updateNetworkState(state)
        }
    }
}

extension ShowLoadingView where Self: UIViewController {
    
    /// NetworkState更新による共通UI処理
    ///
    /// - Parameter networkState: NetworkState
    /// - Parameter errorActionHandler: エラーダイアログタップ時にActionさせたい時渡す エラーのリトライハンドラーより優先
    /// - Parameter force: 強制的に優先させたい処理がある場合渡す
    func updateNetworkState(_ networkState: NetworkState,
                            errorActionHandler: (() -> Void)? = nil,
                            force: ((NetworkState) -> Bool)? = nil) {
        
        // 強制割り込み処理
        guard force == nil
            || force?(networkState) == false else { return }
        
        switch networkState {
        case .error(let error):
            let title: String
            let message: String
            let buttonType: AlertButtonType = .ok(nil)
            if let error = error as? ErrorProtocol {
                title = error.title
                message = error.message
            } else {
                // デバッグ、stgは詳しくエラー出す
                title = R.string.localizable.os_dialogConfirm_title()
                message = error.localizedDescription
            }
            SVProgressHUD.dismiss()
            showAlert(alertable: Alerts.General(
                title: title,
                message: message,
                buttonType: buttonType
            ))
        case .loading:
            SVProgressHUD.show()
        case .normal:
            SVProgressHUD.dismiss()
        }
    }
}
