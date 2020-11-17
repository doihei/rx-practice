//___FILEHEADER___

import RxCocoa
import RxSwift
import Unio

protocol ___VARIABLE_productName___ViewModelType: AnyObject {
    var input: InputWrapper<___VARIABLE_productName___ViewModel.Input> { get }
    var output: OutputWrapper<___VARIABLE_productName___ViewModel.Output> { get }
}

final class ___VARIABLE_productName___ViewModel: UnioStream<___VARIABLE_productName___ViewModel>, ___VARIABLE_productName___ViewModelType {

    convenience init(extra: Extra) {
        self.init(input: Input(),
                  state: State(),
                  extra: extra)
    }
}

extension ___VARIABLE_productName___ViewModel {

    struct Input: InputType {

        /*
         *  EXAMPLE:
         *
         *  let buttonTap = PublishRelay<Void>()
         */
    }

    struct Output: OutputType {
        let networkState: BehaviorRelay<NetworkState>

        /*
         *  EXAMPLE:
         *
         *  let isEnabled: Observable<Bool>
         */
    }

    struct State: StateType {
        let networkState = BehaviorRelay<NetworkState>(value: .normal)
    }

    struct Extra: ExtraType {
        let wireframe: ___VARIABLE_productName___Wireframe
        let useCase: ___VARIABLE_productName___UseCase
    }
}

extension ___VARIABLE_productName___ViewModel {

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let state = dependency.state
        let extra = dependency.extra

        /*
         *  EXAMPLE:
         *
         *  dependency.inputObservable(for: \.buttonTap)
         *      .map { _ in false }
         *      .bind(to: state.isEnabled)
         *      .disposed(by: disposeBag)
         */

        return Output(
            networkState: state.networkState
            /*
             * EXAMPLE:
             *
             * isEnabled: state.isEnabled.asObservable()
             */
        )
    }
}
