//___FILEHEADER___

import APIKit
import RxSwift

final public class ___VARIABLE_productName___GatewayProvider {
    
    private init() {}
    
    static public func provide() -> ___VARIABLE_productName___Gateway {
        return ___VARIABLE_productName___GatewayImpl()
    }
}

public protocol ___VARIABLE_productName___Gateway {
}

final class ___VARIABLE_productName___GatewayImpl: ___VARIABLE_productName___Gateway {
    
    private let session: Session
    
    public init(session: Session = .shared) {
        self.session = session
    }    
}
