//
//  ErrorProtocol.swift
//  Datasource
//
//  Created by doi on 2019/10/09.
//

import Foundation

public protocol ErrorProtocol: Error {
    
    var title: String { get }
    
    var message: String { get }
}
