//
//  UIAlertController+.swift
//  young-jump-ios
//
//  Created by doi on 2019/11/22.
//

import UIKit

extension UIAlertController {
    
    static func showOkAlert(vc: UIViewController,
                            title: String,
                            message: String,
                            style: UIAlertController.Style = .alert,
                            okTitle: String? = R.string.localizable.os_dialogOk(),
                            okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: okTitle, style: .default) { _ in okHandler?() }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showOkCancelAlert(vc: UIViewController,
                                  title: String,
                                  message: String,
                                  style: UIAlertController.Style = .alert,
                                  okTitle: String? = R.string.localizable.os_dialogOk(),
                                  okHandler: (() -> Void)?,
                                  cancelTitle: String? = R.string.localizable.os_dialogCancel(),
                                  cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in okHandler?() }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in cancelHandler?() }
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertController {
    
    static func showActionSheet(vc: UIViewController,
                                title: String,
                                message: String,
                                buttons: [String],
                                selectHandler: @escaping (_ index: Int) -> Void) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        buttons.enumerated().forEach { index, title in
            let action = UIAlertAction(title: title, style: .default) { _ in
                selectHandler(index)
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.popoverPresentationController?.sourceView = vc.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.width / 2, y: vc.view.frame.height, width: 0, height: 0)

        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    static func showCancelableActionSheet(vc: UIViewController,
                                          title: String,
                                          message: String,
                                          buttons: [String],
                                          selectHandler: @escaping (_ index: Int) -> Void,
                                          cancelTitle: String = R.string.localizable.os_dialogCancel(),
                                          cancelHandler: (() -> Void)? = nil) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        buttons.enumerated().forEach { index, title in
            let action = UIAlertAction(title: title, style: .default) { _ in
                selectHandler(index)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.sourceView = vc.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.width / 2, y: vc.view.frame.height, width: 0, height: 0)
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
