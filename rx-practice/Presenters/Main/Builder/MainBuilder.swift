//
//  MainBuilder.swift
//  rx-practice
//
//  Created by daiheidoi on 18/11/2020.
//  Copyright © 2020 and factory inc.. All rights reserved.
//

import UIKit

final class MainBuilder {

    private init() {}

    static func build() -> UIViewController {
        let viewController = MainViewController.instantiate()
        let wireframe = MainWireframeImpl()

        wireframe.viewController = viewController

        let viewModel = MainViewModel(
            extra: .init(
                wireframe: wireframe,
                useCase: MainUseCaseProvider.provide()
            )
        )
    
        viewController.viewModel = viewModel
        
        return viewController
    }
}
