//
//  File.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

public func startInjection(completion: () -> Void) {
    stopInjection()
    completion()
}

public func registerModules(_ modules: Module...) {
    modules.forEach { $0() }
}

public func registerModule(_ module: Module) {
    module()
}

public func stopInjection() {
    SharedResolver.reset()
    GlobalResolver.reset()
    InstanceResolver.reset()
}

/// Registers an element to be unique across the entire app lifecycle
/// - Parameters:
///   - type: Contract the object is going to conform
///   - implementation: Implementation the dependency is going to return
public func instance<T: Injectable>(_ type: Any, _ implementation: T.Type) {
    InstanceResolver.register(type, implementation)
}

/// Registers a shared element to be unique across the entire object lifecycle. This element is going to be released once noone retains it
/// - Parameters:
///   - type: Contract the object is going to conform
///   - implementation: Implementation the dependency is going to return
public func shared<T: Injectable>(_ type: Any, _ implementation: T.Type) {
    SharedResolver.register(type, implementation)
}

/// Registers a singleton element to be unique across the entire app lifecycle. This element is going to be behave as a singleton
/// - Parameters:
///   - type: Contract the object is going to conform
///   - implementation: Implementation the dependency is going to return
public func global<T: Injectable>(_ type: Any, _ implementation: T.Type) {
    GlobalResolver.register(type, implementation)
}

/// Represents the module where types are going to be registered
public typealias Module = () -> Void
