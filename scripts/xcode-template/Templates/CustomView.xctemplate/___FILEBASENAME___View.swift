//___FILEHEADER___

import Reusable
import UIKit

final class ___VARIABLE_productName___View: UIView, NibOwnerLoadable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    
    /// TODO: データ注入
    func setData() {}
}
