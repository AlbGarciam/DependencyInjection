//
//  InstanceResolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

struct InstanceResolver: ResolverContract {
    private static var single: [String: [Injectable.Type]] = [:]

    static func register<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        guard let key = try? getMapKeyFor(type) else {
            return
        }
        var classes = single[key] ?? []
        classes.append(implementation)
        single[key] = classes
    }

    static func resolve<T>(_ type: T.Type) throws -> T! {
        let key = try getMapKeyFor(T.self)
        if let contracts = single[key] {
            return try resolveBestMatch(contracts)
        }
        return nil
    }

    static func reset() {
        single.removeAll()
    }
}
