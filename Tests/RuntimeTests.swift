//
//  SharedResolverTests.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

class RuntimeTests: XCTestCase {
    func testRuntimeCallsAllGet() throws {
        stopInjection()
        Module.called = false
        XCTAssertFalse(Module.called)
        Runtime.loadModules()
        XCTAssertTrue(Module.called)
    }
}
