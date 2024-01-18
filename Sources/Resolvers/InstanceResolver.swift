//
//  InstanceResolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

struct InstanceResolver: ResolverContract {
    private static let mutex = NSRecursiveLock()
    private static var single: [String: [Injectable.Type]] = [:]

    static func register<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        guard let key = try? getMapKeyFor(type) else {
            return
        }
        mutex.withLock {
            var classes = single[key] ?? []
            classes.append(implementation)
            single[key] = classes
        }
    }

    static func resolve<T>(_ type: T.Type) throws -> T! {
        let key = try getMapKeyFor(T.self)
        return try mutex.withLock {
            if let contracts = getRegisteredTypes(key) {
                return try resolveBestMatch(contracts)
            }
            return nil
        }
    }
    
    private static func getRegisteredTypes(_ key: String) -> [Injectable.Type]? {
        mutex.withLock { single[key] }
    }

    static func reset() {
        single.removeAll()
    }
}
