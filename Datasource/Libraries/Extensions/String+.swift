//
//  String+.swift
//  Datasource
//
//  Created by doi on 2019/11/11.
//

import Foundation

extension String {
    
    /// バージョン表記(n.m.l)の文字列をInt型にして返す
    /// n.m.l => n * majorNumberTimes + m * minorNumberTimes + l のInt形式、
    /// nは必須だが m, l はオプションで表記されているものとする。
    /// ex-1) 10 => 10 * majorNumberTimes を返す
    /// ex-2) 10.3 => 10 * majorNumberTImes + 3 * minorNumberTimes を返す
    ///
    /// - Parameters:
    ///   - versionString: n.m.l のバージョン表記文字列
    ///   - majorNumberTimes: nの桁に掛ける数値(ex: 10000)
    ///   - minorNumberTimes: mの桁に掛ける数値(ex: 100)
    /// - Returns: Int
    public func versionStringToInt(majorNumberTimes: Int = 10000,
                                   minorNumberTimes: Int = 100) -> Int {
        let versions = self.components(separatedBy: ".")
        guard versions.count > 2 else {
            return 0
        }

        return versions.enumerated().reduce(0, { lhs, rhs in
            if rhs.0 == 0 {
                return lhs + (Int(rhs.1) ?? 0) * majorNumberTimes
            } else if rhs.0 == 1 {
                return lhs + (Int(rhs.1) ?? 0) * minorNumberTimes
            } else if rhs.0 == 2 {
                return lhs + (Int(rhs.1) ?? 0)
            } else {
                // . で区切られた4つ目以降のバージョン表記は無効とみなす
                return lhs
            }
        })
    }
}
