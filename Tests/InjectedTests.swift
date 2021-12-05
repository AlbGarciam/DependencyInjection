//
//  GlobalResolverTests.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

final class Module: ModuleContract {
    static func get() {
        instance(TypeAContract.self, TypeA.self)
        shared(TypeBContract.self, TypeB.self)
        global(TypeCContract.self, TypeC.self)
    }
}

class InjectedTests: XCTestCase {
    @Injected private var instanceA: TypeAContract
    @Injected private var instanceB: TypeBContract
    @Injected private var instanceC: TypeCContract

    func testInstances() {
        XCTAssertTrue(instanceA is TypeA)
        XCTAssertTrue(instanceB is TypeB)
        XCTAssertTrue(instanceC is TypeC)
    }

    func testSameInstances() throws {
        XCTAssertEqual(ObjectIdentifier(instanceA as AnyObject), ObjectIdentifier(instanceA as AnyObject))
    }
}

fileprivate protocol TypeAContract: Injectable {}
fileprivate final class TypeA: TypeAContract {}

fileprivate protocol TypeBContract: Injectable {}
fileprivate final class TypeB: TypeBContract {}
fileprivate final class TypeB_B: TypeBContract {}

fileprivate protocol TypeCContract: Injectable {}
fileprivate final class TypeC: TypeCContract, Mock {}
fileprivate final class TypeC_B: TypeCContract, Mock {}

fileprivate protocol TypeDContract: Injectable {}
fileprivate final class TypeD: TypeDContract, Primary {}
fileprivate final class TypeD_B: TypeDContract, Primary {}

fileprivate protocol TypeEContract: Injectable {}
fileprivate final class TypeE: TypeEContract, Primary {}
fileprivate final class TypeE_B: TypeEContract, Mock {}

fileprivate protocol TypeFContract: Injectable {}
fileprivate final class TypeF: TypeFContract, Primary {}
fileprivate final class TypeF_B: TypeFContract {}
