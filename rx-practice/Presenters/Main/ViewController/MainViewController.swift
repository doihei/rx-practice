//
//  MainViewController.swift
//  rx-practice
//
//  Created by daiheidoi on 18/11/2020.
//  Copyright © 2020 and factory inc.. All rights reserved.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class MainViewController: UIViewController, StoryboardBased, ShowLoadingView {

    lazy var viewModel: MainViewModelType = undefined()
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.register(cellType: MainCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindInput()
        bindOutput()
    }
}

// MARK: - setup
extension MainViewController {
    
    private func setup() {
        navigationItem.title = R.string.localizable.mainTitle()
    }
}

// MARK: - bind input
extension MainViewController {

    private func bindInput() {
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.didTapCell)
            .disposed(by: disposeBag)
    }
}

// MARK: - bind output
extension MainViewController {
    
    private func bindOutput() {

        viewModel.output.networkState
            .bind(to: rx.networkState)
            .disposed(by: disposeBag)
        
        viewModel.output.data
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Description
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainCell = tableView.dequeueReusableCell(for: indexPath, cellType: MainCell.self)

        cell.setData(viewModel.output.data.value[indexPath.row])
        
        return cell
    }
}
