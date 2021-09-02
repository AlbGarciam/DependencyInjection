//
//  Resolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

protocol ResolverContract {
    static func register<T: Injectable>(_ type: Any, _ implementation: T.Type)

    static func resolve<T>(_ type: T.Type) throws -> T!

    static func resolveBestMatch<T>(_ classes: [Injectable.Type]) throws -> T!
}

extension ResolverContract {
    static func resolveBestMatch<T>(_ classes: [Injectable.Type]) throws -> T! {
        let mocks = classes.filter { $0 is Mock.Type }
        guard mocks.count <= 1 else {
            throw DependencyInjectionError.multipleMockImplementation(T.self)
        }
        if let mock = mocks.first {
            return mock.init() as? T
        }
        let primaries = classes.filter { $0 is Primary.Type }
        guard primaries.count <= 1 else {
            throw DependencyInjectionError.multiplePrimaryImplementation(T.self)
        }
        if let primary = primaries.first {
            return primary.init() as? T
        }
        guard classes.count <= 1 else {
            throw DependencyInjectionError.multipleDefaultImplementation(T.self)
        }
        if let defaultType = classes.first {
            return defaultType.init() as? T
        }
        throw DependencyInjectionError.missingImplementation(T.self)
    }
}
