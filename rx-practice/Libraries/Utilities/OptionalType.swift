//
//  OptionalType.swift
//  young-jump-ios
//
//  Created by doi on 2019/09/10.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { return self }
}
