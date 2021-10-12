//
//  GlobalResolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

struct GlobalResolver: ResolverContract {
    private static var single: [String: [Injectable.Type]] = [:]
    private static var references: [String: AnyObject] = [:]

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
        if let instance = references[key] as? T {
            return instance
        } else if let contracts = single[key],
                  let instance: T = try resolveBestMatch(contracts) {
            references[key] = instance as AnyObject
            return instance
        }
        return nil
    }

    static func reset() {
        single.removeAll()
    }
}
