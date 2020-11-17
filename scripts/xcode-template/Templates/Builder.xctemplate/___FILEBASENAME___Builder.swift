//___FILEHEADER___

import UIKit

final class ___VARIABLE_productName___Builder {

    private init() {}

    static func build() -> UIViewController {
        let viewController = ___VARIABLE_productName___ViewController.instantiate()
        let wireframe = ___VARIABLE_productName___WireframeImpl()

        wireframe.viewController = viewController

        let viewModel = ___VARIABLE_productName___ViewModel(
            extra: .init(
                wireframe: wireframe,
                useCase: ___VARIABLE_productName___UseCaseProvider.provide()
            )
        )
    
        viewController.viewModel = viewModel

        return viewController
    }
}
