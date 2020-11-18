//
//  MainCell.swift
//  rx-practice
//
//  Created by doi on 2020/11/18.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class MainCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var titleLabel: UILabel!
    
    private(set) var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
    func setData(_ data: String) {
        titleLabel.text = data
    }
}
