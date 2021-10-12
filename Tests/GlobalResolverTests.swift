//
//  GlobalResolverTests.swift
//  
//
//  Created by Alberto García-Muñoz on 10/8/21.
//

import XCTest

@testable import DependencyInjection

class GlobalResolverTests: XCTestCase {
    override func setUp() {
        GlobalResolver.register(TypeAContract.self, TypeA.self)
        GlobalResolver.register(TypeBContract.self, TypeB.self)
        GlobalResolver.register(TypeBContract.self, TypeB_B.self)
        GlobalResolver.register(TypeCContract.self, TypeC.self)
        GlobalResolver.register(TypeCContract.self, TypeC_B.self)
        GlobalResolver.register(TypeDContract.self, TypeD.self)
        GlobalResolver.register(TypeDContract.self, TypeD_B.self)
        GlobalResolver.register(TypeEContract.self, TypeE.self)
        GlobalResolver.register(TypeEContract.self, TypeE_B.self)
        GlobalResolver.register(TypeFContract.self, TypeF.self)
        GlobalResolver.register(TypeFContract.self, TypeF_B.self)
    }

    override func tearDown() {
        GlobalResolver.reset()
    }

    func testResolveOptionalContractRaisesError() throws {
        GlobalResolver.register(TypeFContract?.self, TypeF_B.self)
        XCTAssertThrowsError(try GlobalResolver.resolve(TypeFContract?.self))
    }

    func testRegisterSingleInstance() throws {
        XCTAssertNoThrow(try GlobalResolver.resolve(TypeAContract.self))
        XCTAssertTrue(try GlobalResolver.resolve(TypeAContract.self) is TypeA)
    }

    func testRegisterMultipleDefaultInstances() throws {
        XCTAssertThrowsError(try GlobalResolver.resolve(TypeBContract.self))
    }

    func testRegisterMockDefaultInstances() throws {
        XCTAssertThrowsError(try GlobalResolver.resolve(TypeCContract.self))
    }

    func testRegisterPrimaryDefaultInstances() throws {
        XCTAssertThrowsError(try GlobalResolver.resolve(TypeDContract.self))
    }

    func testMockIsResolvedBeforePrimary() throws {
        XCTAssertNoThrow(try GlobalResolver.resolve(TypeEContract.self))
        XCTAssertTrue(try GlobalResolver.resolve(TypeEContract.self) is TypeE_B)
    }

    func testPrimaryIsResolvedBeforeDefault() throws {
        XCTAssertNoThrow(try GlobalResolver.resolve(TypeFContract.self))
        XCTAssertTrue(try GlobalResolver.resolve(TypeFContract.self) is TypeF)
    }

    func testResolvesSameInstances() throws {
        let instanceA = try GlobalResolver.resolve(TypeFContract.self) as AnyObject
        let instanceB = try GlobalResolver.resolve(TypeFContract.self) as AnyObject
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
