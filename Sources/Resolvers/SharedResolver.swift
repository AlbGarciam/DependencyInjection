//
//  SharedResolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

struct SharedResolver: ResolverContract {
    private static var single: [String: [Injectable.Type]] = [:]
    private static var weakReferences = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    static func register<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        let key = String(reflecting: type.self)
        var classes = single[key] ?? []
        classes.append(implementation)
        single[key] = classes
    }

    static func resolve<T>(_ type: T.Type) throws -> T! {
        let key = String(reflecting: type.self)
        if let instance = weakReferences.object(forKey: key as NSString) as? T {
            return instance
        } else if let contracts = single[key],
                  let instance: T = try resolveBestMatch(contracts) {
            weakReferences.setObject(instance as AnyObject, forKey: key as NSString)
            return instance
        }
        return nil
    }

    static func reset() {
        single.removeAll()
        weakReferences.removeAllObjects()
    }
}
