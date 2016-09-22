//
//  ForbindCombineFunctionCallTests.swift
//  Forbind
//
//  Created by Ulrik Damm on 26/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import XCTest

/// Tests binding (=>) the combine function (++) to a function with two
/// parameters. The function should only get called if both combine inputs
/// are valid.
class ForbindCombineFunctionCallTests : XCTestCase {
	func testCombineFunctionCall() {
		let a = (1 ++ 1) => (+)
		XCTAssert(a == 2)
	}
	
	func testCombineFunctionCallOptionalSome() {
		let a = (1 ++ (1 as Int?)) => (+)
		XCTAssert(a != nil)
		XCTAssert(a == 2)
	}
	
	func testCombineFunctionCallOptionalNone() {
		let a = (1 ++ (nil as Int?)) => (+)
		XCTAssert(a == nil)
	}
	
	func testCombineFunctionCallResultOk() {
		let r = Result<Int>.ok(1)
		let a = (1 ++ r) => (+)
		
		switch a {
		case .ok(let value): XCTAssert(value == 2)
		case .error(_): XCTAssert(false)
		}
	}
	
	func testCombineFunctionCallResultError() {
		let r = Result<Int>.error(GenericError())
		let a = (1 ++ r) => (+)
		
		switch a {
		case .ok(_): XCTAssert(false)
		case .error(let error): XCTAssert(error is GenericError)
		}
	}
	
	func testCombineFunctionCallPromise() {
		let p = Promise<Int>()
		let a = (1 ++ p) => (+)
		
		var callbackCalled = false
		
		a.getValue { value in
			callbackCalled = true
			XCTAssert(value == 2)
		}
		
		p.setValue(1)
		
		XCTAssert(callbackCalled)
	}
}
