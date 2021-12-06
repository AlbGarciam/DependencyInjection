//
//  SharedResolverTests.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

class SharedResolverTests: XCTestCase {
    override func setUp() {
        stopInjection()
        SharedResolver.register(TypeAContract.self, TypeA.self)
        SharedResolver.register(TypeBContract.self, TypeB.self)
        SharedResolver.register(TypeBContract.self, TypeB_B.self)
        SharedResolver.register(TypeCContract.self, TypeC.self)
        SharedResolver.register(TypeCContract.self, TypeC_B.self)
        SharedResolver.register(TypeDContract.self, TypeD.self)
        SharedResolver.register(TypeDContract.self, TypeD_B.self)
        SharedResolver.register(TypeEContract.self, TypeE.self)
        SharedResolver.register(TypeEContract.self, TypeE_B.self)
        SharedResolver.register(TypeFContract.self, TypeF.self)
        SharedResolver.register(TypeFContract.self, TypeF_B.self)
    }

    func testResolveOptionalContractRaisesError() throws {
        SharedResolver.register(TypeFContract?.self, TypeF_B.self)
        XCTAssertThrowsError(try SharedResolver.resolve(TypeFContract?.self))
    }

    func testRegisterSingleInstance() throws {
        XCTAssertNoThrow(try SharedResolver.resolve(TypeAContract.self))
        XCTAssertTrue(try SharedResolver.resolve(TypeAContract.self) is TypeA)
    }

    func testRegisterMultipleDefaultInstances() throws {
        XCTAssertThrowsError(try SharedResolver.resolve(TypeBContract.self))
    }

    func testRegisterMockDefaultInstances() throws {
        XCTAssertThrowsError(try SharedResolver.resolve(TypeCContract.self))
    }

    func testRegisterPrimaryDefaultInstances() throws {
        XCTAssertThrowsError(try SharedResolver.resolve(TypeDContract.self))
    }

    func testMockIsResolvedBeforePrimary() throws {
        XCTAssertNoThrow(try SharedResolver.resolve(TypeEContract.self))
        XCTAssertTrue(try SharedResolver.resolve(TypeEContract.self) is TypeE_B)
    }

    func testPrimaryIsResolvedBeforeDefault() throws {
        XCTAssertNoThrow(try SharedResolver.resolve(TypeFContract.self))
        XCTAssertTrue(try SharedResolver.resolve(TypeFContract.self) is TypeF)
    }

    func testResolvesSameInstances() throws {
        let instanceA = try SharedResolver.resolve(TypeFContract.self) as AnyObject
        let instanceB = try SharedResolver.resolve(TypeFContract.self) as AnyObject
        XCTAssertEqual(ObjectIdentifier(instanceA).hashValue, ObjectIdentifier(instanceB).hashValue)
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
