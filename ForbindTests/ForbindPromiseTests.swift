//
//  ForbindPromiseTests.swift
//  Forbind
//
//  Created by Ulrik Damm on 09/05/15.
//
//

import Foundation
import XCTest

class ForbindPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = Promise<Int>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = Promise<Int>()
		
		promise.setValue(1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise = Promise(value: 1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = Promise<Int>()
		
		var gotValue1 = false
		var gotValue2 = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue1 = true
		}
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue2 = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
	func testEquals() {
		let promise1 = Promise<Int>()
		let promise2 = Promise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == true)
			gotValue = true
		}
		
		promise1.setValue(1)
		promise2.setValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testEqualsFalse() {
		let promise1 = Promise<Int>()
		let promise2 = Promise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == false)
			gotValue = true
		}
		
		promise1.setValue(1)
		promise2.setValue(2)
		
		XCTAssert(gotValue)
	}
}

class ForbindOptionalPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = OptionalPromise<Int>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		promise.setSomeValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = OptionalPromise<Int>()
		
		var gotValue = false
		
		promise.setSomeValue(1)
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise = OptionalPromise(value: 1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = OptionalPromise<Int>()
		
		var gotValue1 = false
		var gotValue2 = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue1 = true
		}
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue2 = true
		}
		
		promise.setSomeValue(1)
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
	func testGetNil() {
		let promise = OptionalPromise<Int>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == nil)
			gotValue = true
		}
		
		promise.setNil()
		
		XCTAssert(gotValue)
	}
	
	func testEquals() {
		let promise1 = OptionalPromise<Int>()
		let promise2 = OptionalPromise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == true)
			gotValue = true
		}
		
		promise1.setSomeValue(1)
		promise2.setSomeValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testEqualsNil() {
		let promise1 = OptionalPromise<Int>()
		let promise2 = OptionalPromise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == nil)
			gotValue = true
		}
		
		promise1.setSomeValue(1)
		promise2.setNil()
		
		XCTAssert(gotValue)
	}
	
	func testEqualsFalse() {
		let promise1 = OptionalPromise<Int>()
		let promise2 = OptionalPromise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == false)
			gotValue = true
		}
		
		promise1.setSomeValue(1)
		promise2.setSomeValue(2)
		
		XCTAssert(gotValue)
	}
}

class ForbindResultPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = ResultPromise<Int>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue = true
		}
		
		promise.setOkValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = ResultPromise<Int>()
		
		var gotValue = false
		
		promise.setOkValue(1)
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise = ResultPromise(value: .Ok(Box(1)))
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = ResultPromise<Int>()
		
		var gotValue1 = false
		var gotValue2 = false
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue1 = true
		}
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue2 = true
		}
		
		promise.setOkValue(1)
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
	func testGetError() {
		let promise = ResultPromise<Int>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == .Error(genericError))
			gotValue = true
		}
		
		promise.setError(genericError)
		
		XCTAssert(gotValue)
	}
	
	func testEquals() {
		let promise1 = ResultPromise<Int>()
		let promise2 = ResultPromise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == .Ok(Box(true)))
			gotValue = true
		}
		
		promise1.setOkValue(1)
		promise2.setOkValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testEqualsError() {
		let promise1 = ResultPromise<Int>()
		let promise2 = ResultPromise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			switch value {
			case .Error(let e): gotValue = true
			case _: XCTAssert(false)
			}
		}
		
		promise1.setOkValue(1)
		promise2.setError(genericError)
		
		XCTAssert(gotValue)
	}
	
	func testEqualsFalse() {
		let promise1 = ResultPromise<Int>()
		let promise2 = ResultPromise<Int>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == .Ok(Box(false)))
			gotValue = true
		}
		
		promise1.setOkValue(1)
		promise2.setOkValue(2)
		
		XCTAssert(gotValue)
	}
}
