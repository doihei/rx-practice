//
//  NetworkState.swift
//  young-jump-ios
//
//  Created by doi on 2019/10/09.
//

import Foundation

/// ネットワーク状態
enum NetworkState {
    case loading
    case normal
    case error(error: Error)
}

extension NetworkState {
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}