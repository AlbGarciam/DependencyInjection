//
//  DependencyInjectionError.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

enum DependencyInjectionError: Error, CustomStringConvertible {
    case multipleMockImplementation(_ type: Any)
    case multiplePrimaryImplementation(_ type: Any)
    case multipleDefaultImplementation(_ type: Any)
    case missingImplementation(_ type: Any)

    var description: String {
        switch self {
        case .multipleMockImplementation(let type):
            return "Multiple Mocks registered for the same type: \(type)"
        case .multiplePrimaryImplementation(let type):
            return "Multiple Primaries registered for the same type: \(type)"
        case .multipleDefaultImplementation(let type):
            return "Multiple Defaults registered for the same type: \(type)"
        case .missingImplementation(let type):
            return "Missing implementation for type: \(type)"
        }
    }
}
