//___FILEHEADER___

import Reusable
import RxSwift
import UIKit

final class ___VARIABLE_productName___ItemCell: UICollectionViewCell, NibReusable {

    private(set) var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
    /// TODO: データ注入
    func setData() {}
}
