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
    modules.forEach { $0.completion() }
}

public func stopInjection() {
    SharedResolver.reset()
    GlobalResolver.reset()
    InstanceResolver.reset()
}

public struct Module {
    public typealias Completion = () -> Void

    var completion: Completion
    public init(_ completion: @escaping Completion) {
        self.completion = completion
    }

    /// Registers an element to be unique across the entire app lifecycle
    /// - Parameters:
    ///   - type: Contract the object is going to conform
    ///   - implementation: Implementation the dependency is going to return
    public static func instance<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        SharedResolver.register(type, implementation)
    }

    /// Registers a shared element to be unique across the entire object lifecycle. This element is going to be released once noone retains it
    /// - Parameters:
    ///   - type: Contract the object is going to conform
    ///   - implementation: Implementation the dependency is going to return
    public static func shared<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        SharedResolver.register(type, implementation)
    }

    /// Registers a singleton element to be unique across the entire app lifecycle. This element is going to be behave as a singleton
    /// - Parameters:
    ///   - type: Contract the object is going to conform
    ///   - implementation: Implementation the dependency is going to return
    public static func global<T: Injectable>(_ type: Any, _ implementation: T.Type) {
        GlobalResolver.register(type, implementation)
    }
}
