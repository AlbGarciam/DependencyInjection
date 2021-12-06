//
//  SharedResolverTests.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

class RuntimeTests: XCTestCase {
    override func setUp() {
        stopInjection()
        Module.called = false
    }

    func testRuntimeCallsAllGet() throws {
        XCTAssertFalse(Module.called)
        Runtime.loadModules()
        XCTAssertTrue(Module.called)
    }
}
