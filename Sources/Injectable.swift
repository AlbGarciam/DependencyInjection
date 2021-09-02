//
//  File.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import Foundation

public protocol Injectable {
    init()
}

/// Used to identify the type as a mock. It will have the highest priority when resolving the instance
public protocol Mock: Injectable {}

/// Used to identify the type as the preferred instance. It will have the second-highest priority when resolving the instance
public protocol Primary: Injectable {}
