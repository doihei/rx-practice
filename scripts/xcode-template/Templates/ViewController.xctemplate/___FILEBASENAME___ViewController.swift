//___FILEHEADER___

import Reusable
import RxSwift
import UIKit

final class ___VARIABLE_productName___ViewController: UIViewController, StoryboardBased, ShowLoadingView {

    lazy var viewModel: ___VARIABLE_productName___ViewModelType = undefined()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }
}

// MARK: - bind input
extension ___VARIABLE_productName___ViewController {

    private func bindInput() {
        /*
         *  EXAMPLE:
         *
         *  let input = viewModel.input
         *
         *  button.rx.tap
         *      .bind(to: input.accept(for: \.buttonTap))
         *      .disposed(by: disposeBag)
         */
    }
}

// MARK: - bind output
extension ___VARIABLE_productName___ViewController {
    
    private func bindOutput() {

        viewModel.output.networkState
            .bind(to: rx.networkState)
            .disposed(by: disposeBag)

        /*
         *  EXAMPLE:
         *
         *  let output = viewModel.output
         *
         *  output.observable(for: \.isEnabled)
         *      .bind(to: button.rx.isEnabled)
         *      .disposed(by: disposeBag)
         *
         *  print("rawValue of isEnabled = \(output.value(for: \.isEnabled))")
         */
    }
}
