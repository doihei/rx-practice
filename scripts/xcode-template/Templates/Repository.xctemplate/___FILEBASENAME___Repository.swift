//___FILEHEADER___

import Datasource
import RxSwift

final class ___VARIABLE_productName___RepositoryProvider {

    private init() {}
    
    static func provide() -> ___VARIABLE_productName___Repository {
        return ___VARIABLE_productName___RepositoryImpl(api: ___VARIABLE_productName___APIGatewayProvider.provide())
    }
}

protocol ___VARIABLE_productName___Repository {
}

final class ___VARIABLE_productName___RepositoryImpl: ___VARIABLE_productName___Repository {
    
    private let api: ___VARIABLE_productName___APIGateway
    
    init(api: ___VARIABLE_productName___APIGateway) {
        self.api = api
    }
}
