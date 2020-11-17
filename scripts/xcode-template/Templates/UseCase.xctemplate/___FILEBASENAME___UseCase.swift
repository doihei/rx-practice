//___FILEHEADER___

import RxSwift

final class ___VARIABLE_productName___UseCaseProvider {
    
    private init() {}
    
    static func provide() -> ___VARIABLE_productName___UseCase {
        return ___VARIABLE_productName___UseCaseImpl(repository: ___VARIABLE_methodName______VARIABLE_productName___RepositoryProvider.provide())
    }
}

protocol ___VARIABLE_productName___UseCase {
}

final class ___VARIABLE_productName___UseCaseImpl: ___VARIABLE_productName___UseCase {
    
    private let repository: ___VARIABLE_methodName______VARIABLE_productName___Repository
    
    init(repository: ___VARIABLE_methodName______VARIABLE_productName___Repository) {
        self.repository = repository
    }
}
