//
//  InstanceResolver.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

class InstanceResolverTests: XCTestCase {
    override func setUp() {
        InstanceResolver.register(TypeAContract.self, TypeA.self)
        InstanceResolver.register(TypeBContract.self, TypeB.self)
        InstanceResolver.register(TypeBContract.self, TypeB_B.self)
        InstanceResolver.register(TypeCContract.self, TypeC.self)
        InstanceResolver.register(TypeCContract.self, TypeC_B.self)
        InstanceResolver.register(TypeDContract.self, TypeD.self)
        InstanceResolver.register(TypeDContract.self, TypeD_B.self)
        InstanceResolver.register(TypeEContract.self, TypeE.self)
        InstanceResolver.register(TypeEContract.self, TypeE_B.self)
        InstanceResolver.register(TypeFContract.self, TypeF.self)
        InstanceResolver.register(TypeFContract.self, TypeF_B.self)
    }

    override func tearDown() {
        InstanceResolver.reset()
    }

    func testRegisterSingleInstance() throws {

        XCTAssertNoThrow(try InstanceResolver.resolve(TypeAContract.self))
        XCTAssertTrue(try InstanceResolver.resolve(TypeAContract.self) is TypeA)
    }

    func testRegisterMultipleDefaultInstances() throws {
        XCTAssertThrowsError(try InstanceResolver.resolve(TypeBContract.self))
    }

    func testRegisterMockDefaultInstances() throws {
        XCTAssertThrowsError(try InstanceResolver.resolve(TypeCContract.self))
    }

    func testRegisterPrimaryDefaultInstances() throws {
        XCTAssertThrowsError(try InstanceResolver.resolve(TypeDContract.self))
    }

    func testMockIsResolvedBeforePrimary() throws {
        XCTAssertNoThrow(try InstanceResolver.resolve(TypeEContract.self))
        XCTAssertTrue(try InstanceResolver.resolve(TypeEContract.self) is TypeE_B)
    }

    func testPrimaryIsResolvedBeforeDefault() throws {
        XCTAssertNoThrow(try InstanceResolver.resolve(TypeFContract.self))
        XCTAssertTrue(try InstanceResolver.resolve(TypeFContract.self) is TypeF)
    }

    func testResolvesDifferentInstances() throws {
        let instanceA = try InstanceResolver.resolve(TypeFContract.self) as AnyObject
        let instanceB = try InstanceResolver.resolve(TypeFContract.self) as AnyObject
        XCTAssertNotEqual(ObjectIdentifier(instanceA), ObjectIdentifier(instanceB))
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
