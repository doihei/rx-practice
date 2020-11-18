//
//  MainWireframe.swift
//  rx-practice
//
//  Created by daiheidoi on 18/11/2020.
//  Copyright © 2020 and factory inc.. All rights reserved.
//

import UIKit

protocol MainWireframe: AnyObject {}

final class MainWireframeImpl: MainWireframe {

    weak var viewController: UIViewController?
    weak var delegate: MainWireframeDelegate?
}

protocol MainWireframeDelegate: AnyObject {}
