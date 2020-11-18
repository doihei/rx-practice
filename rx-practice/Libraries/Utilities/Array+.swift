//
//  Array+.swift
//  young-jump-ios
//
//  Created by doi on 2019/09/10.
//

import Foundation

extension Array {
    
    /// index指定optional取得
    ///
    /// - Parameter index: Int
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// indexをclosureで持ち回しての生成
    ///
    /// - Parameters:
    ///   - count: 作成数
    ///   - closure: 生成クロージャ
    init(count: Int, repeating closure: (Int) -> Element) {
        self = (0..<count).map {
            closure($0)
        }
    }
}
