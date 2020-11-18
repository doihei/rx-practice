//
//  Alertable.swift
//  young-jump-ios
//
//  Created by doi on 2020/01/22.
//

import Foundation

public protocol Alertable {
    var title: String { get }
    var message: String { get }
    var buttonType: AlertButtonType { get }
}

public struct AlertButton {
    public let okTitle: String
    public let okHandler: Alerts.Handler?
    public let hasCancelButton: Bool
    public let cancelTitle: String
    public let cancelHandler: Alerts.Handler?
    
    public init(okTitle: String? = nil,
                okHandler: Alerts.Handler? = nil,
                hasCancelButton: Bool = false,
                cancelTitle: String? = nil,
                cancelHandler: Alerts.Handler? = nil) {
        self.okTitle = okTitle ?? R.string.localizable.os_dialogOk()
        self.okHandler = okHandler
        self.hasCancelButton = hasCancelButton
        self.cancelTitle = cancelTitle ?? R.string.localizable.os_dialogCancel()
        self.cancelHandler = cancelHandler
    }
}

public enum AlertButtonType {
    case ok(Alerts.Handler?)
    case okCancel(Alerts.Handler)
    case custom(AlertButton)
    
    public var okTitle: String {
        switch self {
        case .ok,
             .okCancel:
            return R.string.localizable.os_dialogOk()
        case .custom(let button):
            return button.okTitle
        }
    }
    
    public var okHandler: Alerts.Handler? {
        switch self {
        case .ok(let handler):
            return handler
        case .okCancel(let handler):
            return handler
        case .custom(let button):
            return button.okHandler
        }
    }
    
    public var cancelTitle: String {
        switch self {
        case .ok:
            return ""
        case .okCancel:
            return R.string.localizable.os_dialogCancel()
        case .custom(let button):
            return button.cancelTitle
        }
    }
    
    public var hasCancelButton: Bool {
        switch self {
        case .ok:
            return false
        case .okCancel:
            return true
        case .custom(let button):
            return button.hasCancelButton
        }
    }
    
    public var cancelHandler: Alerts.Handler? {
        switch self {
        case .ok, .okCancel:
            return nil
        case .custom(let button):
            return button.cancelHandler
        }
    }
}
