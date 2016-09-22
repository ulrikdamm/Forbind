//
//  ForbindCombineValueTests.swift
//  Forbind
//
//  Created by Ulrik Damm on 26/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import XCTest

/// Tests the combine function (++) for combining two values into a tuple
/// Combine should fail if either of the values are nil or an error
/// Combine also supports promises, and will be upgraded to a promise if
/// any of the arguments are a promise
class ForbindCombineValueTests : XCTestCase {
	func testCombineValueValue() {
		let a = 1 ++ 1
		
		switch a {
		case (1, 1): XCTAssert(true)
		case _: XCTAssert(false)
		}
	}
	
	func testCombineValueOptionalSome() {
		let a = 1 ++ (1 as Int?)
		
		switch a {
		case .some(1, 1): XCTAssert(true)
		case _: XCTAssert(false)
		}
	}
	
	func testCombineValueOptionalNone() {
		let a = 1 ++ (nil as Int?)
		
		XCTAssert(a == nil)
	}
	
	func testCombineValueResultOk() {
		let a = 1 ++ Result<Int>(1)
		
		switch a {
		case .ok(let value):
			switch value {
			case (1, 1): XCTAssert(true)
			case _: XCTAssert(false)
			}
		case _: XCTAssert(false)
		}
	}
	
	func testCombineValueResultError() {
		let a = 1 ++ Result<Int>(GenericError())
		
		switch a {
		case .error(let error): XCTAssert(error is GenericError)
		case _: XCTAssert(false)
		}
	}
	
	func testCombineValuePromise() {
		let p = Promise<Int>()
		let a = 1 ++ p
		
		var callbackCalled = false
		
		a.getValue { value in
			switch value {
			case (1, 1): XCTAssert(true)
			case _: XCTAssert(false)
			}
			
			callbackCalled = true
		}
		
		p.setValue(1)
		
		XCTAssert(callbackCalled)
	}
	
	func testCombineValueOptionalPromiseSome() {
		let p = Promise<Int?>()
		let a = 1 ++ p
		
		var callbackCalled = false
		
		a.getValue { value in
			switch value {
			case .some(1, 1): XCTAssert(true)
			case _: XCTAssert(false)
			}
			
			callbackCalled = true
		}
		
		p.setValue(1)
		
		XCTAssert(callbackCalled)
	}
	
	func testCombineValueOptionalPromiseNone() {
		let p = Promise<Int?>()
		let a = 1 ++ p
		
		var callbackCalled = false
		
		a.getValue { value in
			XCTAssert(value == nil)
			callbackCalled = true
		}
		
		p.setValue(nil)
		
		XCTAssert(callbackCalled)
	}
	
	func testCombineValueResultPromiseOk() {
		let p = Promise<Result<Int>>()
		let a = 1 ++ p
		
		var callbackCalled = false
		
		a.getValue { value in
			switch value {
			case .ok(let value):
				switch value {
				case (1, 1): XCTAssert(true)
				case _: XCTAssert(false)
				}
			case _: XCTAssert(false)
			}
			
			callbackCalled = true
		}
		
		p.setValue(.ok(1))
		
		XCTAssert(callbackCalled)
	}
	
	func testCombineValueResultPromiseError() {
		let p = Promise<Result<Int>>()
		let a = 1 ++ p
		
		var callbackCalled = false
		
		a.getValue { value in
			switch value {
			case .error(let error): XCTAssert(error is GenericError)
			case _: XCTAssert(false)
			}
			
			callbackCalled = true
		}
		
		p.setValue(.error(GenericError()))
		
		XCTAssert(callbackCalled)
	}
}
