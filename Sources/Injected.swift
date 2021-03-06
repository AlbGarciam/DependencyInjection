//
//  Injected.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

@propertyWrapper
public struct Injected<Dependency> {
    private var dependency: Dependency!
    public var wrappedValue: Dependency {
        mutating get {
            do {
                if let dependency = dependency {
                    return dependency
                }
                let instance: Dependency = try resolve()
                self.dependency = instance
                return instance
            } catch {
                let errorMessage = (error as? DependencyInjectionError)?.description ?? error.localizedDescription
                fatalError(errorMessage)
            }
        }

        set { dependency = newValue }
    }

    public init() {}

    private func resolve<T>() throws -> T {
        Runtime.loadModules()
        guard let instance = try GlobalResolver.resolve(T.self) ??
                                 SharedResolver.resolve(T.self) ??
                                 InstanceResolver.resolve(T.self) else {
            throw DependencyInjectionError.missingImplementation(T.self)
        }
        return instance
    }
}

