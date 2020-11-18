//
//  MainUseCase.swift
//  rx-practice
//
//  Created by doi on 2020/11/18.
//

import RxSwift

final class MainUseCaseProvider {
    
    private init() {}
    
    static func provide() -> MainUseCase {
        return MainUseCaseImpl()
    }
}

protocol MainUseCase {
    func get() -> Observable<[String]>
}

final class MainUseCaseImpl: MainUseCase {
    
    init() {}
    
    func get() -> Observable<[String]> {
        return .just(
            [
                R.string.localizable.mainFirst_lesson()
            ]
        )
    }
}
