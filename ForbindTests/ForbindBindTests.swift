//
//  ForbindBindTests.swift
//  Forbind
//
//  Created by Ulrik Damm on 26/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import XCTest

/// Tests binding (=>) a value to a function. That function should only get
/// called if and when the value is valid. If the value is invalid, the
/// binding will quit early, eventually returning an error.
class ForbindBindTests : XCTestCase {
	func testBindValue() {
		let a = 1
		
		let b = (a => increment)
		
		XCTAssert(b == 2)
	}
	
	func testBindOptionalSome() {
		let a : Int? = 1
		
		let b = (a => increment)
		
		XCTAssert(b != nil)
		XCTAssert(b == 2)
	}
	
	func testBindOptionalNone() {
		let a : Int? = nil
		
		let b = (a => increment)
		
		XCTAssert(b == nil)
	}
	
	func testBindResultOk() {
		let a = Result<Int>(1)
		
		let b = (a => increment)
		
		switch b {
		case .Ok(let box): XCTAssert(box.value == 2)
		case .Error(let error): XCTAssert(false)
		}
	}
	
	func testBindResultError() {
		let a = Result<Int>(genericError)
		
		let b = (a => increment)
		
		switch b {
		case .Ok(let box): XCTAssert(false)
		case .Error(let error): XCTAssert(error == genericError)
		}
	}
	
	func testBindPromise() {
		let a = Promise<Int>()
		
		let b = (a => increment)
		
		var callbackCalled = false
		
		b.getValue { value in
			XCTAssert(value == 2)
			callbackCalled = true
		}
		
		a.setValue(1)
		XCTAssert(callbackCalled)
	}
	
	func testBindOptionalPromiseSome() {
		let a = OptionalPromise<Int>()
		
		let b = (a => increment)
		
		var callbackCalled = false
		
		b.getValue { value in
			XCTAssert(value != nil)
			XCTAssert(value == 2)
			callbackCalled = true
		}
		
		a.setValue(1)
		XCTAssert(callbackCalled)
	}
	
	func testBindOptionalPromiseNone() {
		let a = OptionalPromise<Int>()
		
		let b = (a => increment)
		
		var callbackCalled = false
		
		b.getValue { value in
			XCTAssert(value == nil)
			callbackCalled = true
		}
		
		a.setValue(nil)
		XCTAssert(callbackCalled)
	}
	
	func testBindResultPromiseOk() {
		let a = ResultPromise<Int>()
		
		let b = (a => increment)
		
		var callbackCalled = false
		
		b.getValue { value in
			switch value {
			case .Ok(let box): XCTAssert(box.value == 2)
			case .Error(let error): XCTAssert(false)
			}
			
			callbackCalled = true
		}
		
		a.setOkValue(1)
		XCTAssert(callbackCalled)
	}
	
	func testBindResultPromiseError() {
		let a = ResultPromise<Int>()
		
		let b = (a => increment)
		
		var callbackCalled = false
		
		b.getValue { value in
			switch value {
			case .Ok(let box): XCTAssert(false)
			case .Error(let error): XCTAssert(error == genericError)
			}
			
			callbackCalled = true
		}
		
		a.setError(genericError)
		XCTAssert(callbackCalled)
	}
}
