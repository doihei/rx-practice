//
//  MainViewModel.swift
//  rx-practice
//
//  Created by daiheidoi on 18/11/2020.
//  Copyright © 2020 and factory inc.. All rights reserved.
//

import RxCocoa
import RxSwift
import Unio

protocol MainViewModelType: AnyObject {
    var input: InputWrapper<MainViewModel.Input> { get }
    var output: OutputWrapper<MainViewModel.Output> { get }
}

final class MainViewModel: UnioStream<MainViewModel>, MainViewModelType {

    convenience init(extra: Extra) {
        self.init(input: Input(),
                  state: State(),
                  extra: extra)
    }
}

extension MainViewModel {

    struct Input: InputType {
        let didTapCell = PublishRelay<Int>()
    }

    struct Output: OutputType {
        let networkState: BehaviorRelay<NetworkState>
        let data: BehaviorRelay<[String]>
    }

    struct State: StateType {
        let networkState = BehaviorRelay<NetworkState>(value: .normal)
        let data = BehaviorRelay<[String]>(value: [])
    }

    struct Extra: ExtraType {
        let wireframe: MainWireframe
        let useCase: MainUseCase
    }
}

extension MainViewModel {

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let state = dependency.state
        let extra = dependency.extra

        extra.useCase.get()
            .bind(to: state.data)
            .disposed(by: disposeBag)
        
        return Output(
            networkState: state.networkState,
            data: state.data
        )
    }
}
