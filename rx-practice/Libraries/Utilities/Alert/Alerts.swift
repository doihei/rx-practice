//
//  Alerts.swift
//  young-jump-ios
//
//  Created by doi on 2019/11/22.
//

import Foundation

public final class Alerts {
    
    public typealias Handler = () -> Void
    
    private init() {}
    
    public struct General: Alertable {
        public var title: String
        public var message: String
        public var buttonType: AlertButtonType
        
        public init(title: String, message: String, buttonType: AlertButtonType) {
            self.title = title
            self.message = message
            self.buttonType = buttonType
        }
    }
}

// MARK: - Common
extension Alerts {
    
    enum Common: Alertable {
        case unimplemented
        
        var title: String {
            switch self {
            case .unimplemented:
                return R.string.localizable.os_dialogUnimplemented_title()
            }
        }
        
        var message: String {
            switch self {
            case .unimplemented:
                return R.string.localizable.os_dialogUnimplemented_message()
            }
        }
        
        var buttonType: AlertButtonType {
            switch self {
            case .unimplemented:
                return .ok(nil)
            }
        }
    }
}
