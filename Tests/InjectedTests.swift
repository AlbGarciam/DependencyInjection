//
//  GlobalResolverTests.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

final class Module: ModuleContract {
    static var called = false

    static func get() {
        instance(TypeXContract.self, TypeX.self)
        shared(TypeYContract.self, TypeY.self)
        global(TypeZContract.self, TypeZ.self)
        called = true
    }
}

class InjectedTests: XCTestCase {
    @Injected private var instanceX: TypeXContract
    @Injected private var instanceY: TypeYContract
    @Injected private var instanceZ: TypeZContract

    func testInstances() {
        stopInjection()
        XCTAssertTrue(instanceX is TypeX)
        XCTAssertTrue(instanceY is TypeY)
        XCTAssertTrue(instanceZ is TypeZ)
    }

    func testSameInstances() throws {
        XCTAssertEqual(ObjectIdentifier(instanceX as AnyObject), ObjectIdentifier(instanceX as AnyObject))
    }
}

fileprivate protocol TypeXContract: Injectable {}
fileprivate final class TypeX: TypeXContract {}

fileprivate protocol TypeYContract: Injectable {}
fileprivate final class TypeY: TypeYContract {}

fileprivate protocol TypeZContract: Injectable {}
fileprivate final class TypeZ: TypeZContract, Mock {}
