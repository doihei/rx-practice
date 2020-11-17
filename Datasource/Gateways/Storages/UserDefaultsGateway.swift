//
//  UserDefaultsGateway.swift
//  Datasource
//
//  Created by doi on 2019/10/07.
//

import SwiftyUserDefaults

final public class UserDefaultsGatewayProvider {
    
    private init() {}
    
    static public func provide() -> UserDefaultsGateway {
        return UserDefaultsGatewayImpl()
    }
}

public protocol UserDefaultsGateway {
    
    func set<T: DefaultsSerializable>(_ key: DefaultsKey<T>, _ value: T) where T: DefaultsSerializable, T == T.T
    func set<T: DefaultsSerializable>(_ key: DefaultsKey<T?>, _ value: T?) where T: DefaultsSerializable, T == T.T
    func get<T: DefaultsSerializable>(_ key: DefaultsKey<T>) -> T where T: DefaultsSerializable, T == T.T
    func get<T: DefaultsSerializable>(_ key: DefaultsKey<T>) -> T? where T: DefaultsSerializable, T == T.T
    func get<T: DefaultsSerializable>(_ key: DefaultsKey<T?>) -> T? where T: DefaultsSerializable, T == T.T
}

final class UserDefaultsGatewayImpl: UserDefaultsGateway {
    
    public init() {}
    
    public func set<T>(_ key: DefaultsKey<T>, _ value: T) where T: DefaultsSerializable, T == T.T {
        Defaults[key: key] = value
    }
    
    public func set<T>(_ key: DefaultsKey<T?>, _ value: T?) where T: DefaultsSerializable, T == T.T {
        Defaults[key: key] = value
    }
    
    public func get<T>(_ key: DefaultsKey<T>) -> T where T: DefaultsSerializable, T == T.T {
        return Defaults[key: key]
    }
    
    func get<T>(_ key: DefaultsKey<T>) -> T? where T: DefaultsSerializable, T == T.T {
        return Defaults[key: key]
    }
    
    public func get<T>(_ key: DefaultsKey<T?>) -> T? where T: DefaultsSerializable, T == T.T {
        return Defaults[key: key]
    }
}
