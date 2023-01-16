//
//  GlobalResolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

struct GlobalResolver: ResolverContract {
    private static let queue = DispatchQueue(label: "global-resolver", attributes: .concurrent)
    private static var single: [String: [Injectable.Type]] = [:]
    private static var references: [String: AnyObject] = [:]

    static func register<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        guard let key = try? getMapKeyFor(type) else {
            return
        }
        queue.sync(flags: .barrier) {
            var classes = single[key] ?? []
            classes.append(implementation)
            single[key] = classes
        }
    }

    static func resolve<T>(_ type: T.Type) throws -> T! {
        let key = try getMapKeyFor(T.self)
        if let instance: T = getReference(key) {
            return instance
        } else if let contracts = getRegisteredTypes(key),
                  let instance: T = try resolveBestMatch(contracts) {
            queue.sync(flags: .barrier) { references[key] = instance as AnyObject }
            return instance
        }
        return nil
    }
    
    private static func getReference<T>(_ key: String) -> T? {
        queue.sync { references[key] as? T }
    }
    
    private static func getRegisteredTypes(_ key: String) -> [Injectable.Type]? {
        queue.sync { single[key] }
    }

    static func reset() {
        single.removeAll()
    }
}
