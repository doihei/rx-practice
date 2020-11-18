//
//  ShowAlertView.swift
//  young-jump-ios
//
//  Created by doi on 2019/11/22.
//

import UIKit

protocol ShowAlertView: class {
    func showAlert(alertable: Alertable)
}

extension ShowAlertView where Self: UIViewController {
    
    func showAlert(alertable: Alertable) {
        if alertable.buttonType.hasCancelButton {
            self.showCancelableAlert(alertable: alertable)
        } else {
            self.showOkAlert(alertable: alertable)
        }
    }
    
    private func showOkAlert(alertable: Alertable) {
        UIAlertController.showOkAlert(
            vc: self,
            title: alertable.title,
            message: alertable.message,
            okTitle: alertable.buttonType.okTitle,
            okHandler: alertable.buttonType.okHandler
        )
    }
    
    private func showCancelableAlert(alertable: Alertable) {
        UIAlertController.showOkCancelAlert(
            vc: self,
            title: alertable.title,
            message: alertable.message,
            okTitle: alertable.buttonType.okTitle,
            okHandler: alertable.buttonType.okHandler,
            cancelTitle: alertable.buttonType.cancelTitle,
            cancelHandler: alertable.buttonType.cancelHandler
        )
    }
}
