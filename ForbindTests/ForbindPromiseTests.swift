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
		let promise = Promise<Int?>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = Promise<Int?>()
		
		var gotValue = false
		
		promise.setValue(1)
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise : Promise<Int?> = Promise(value: 1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = Promise<Int?>()
		
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
	
	func testGetNil() {
		let promise = Promise<Int?>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == nil)
			gotValue = true
		}
		
		promise.setValue(nil)
		
		XCTAssert(gotValue)
	}
	
	func testEquals() {
		let promise1 = Promise<Int?>()
		let promise2 = Promise<Int?>()
		
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
	
	func testEqualsNil() {
		let promise1 = Promise<Int?>()
		let promise2 = Promise<Int?>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == nil)
			gotValue = true
		}
		
		promise1.setValue(1)
		promise2.setValue(nil)
		
		XCTAssert(gotValue)
	}
	
	func testEqualsFalse() {
		let promise1 = Promise<Int?>()
		let promise2 = Promise<Int?>()
		
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
	
//	func testOnSome() {
//		let promise : Promise<Int?> = Promise(value: 1)
//		
//		var gotValue = false
//		
//		promise.onSome() { value in
//			XCTAssert(value == 1)
//			gotValue = true
//		}
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testOnSomeNoValue() {
//		let promise = OptionalPromise<Int>(value: nil)
//		
//		var gotValue = false
//		
//		promise.onSome() { value in
//			gotValue = true
//		}
//		
//		XCTAssert(gotValue == false)
//	}
//	
//	func testOnNil() {
//		let promise = OptionalPromise<Int>(value: nil)
//		
//		var gotValue = false
//		
//		promise.onNil() {
//			gotValue = true
//		}
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testOnNilNoNil() {
//		let promise = OptionalPromise(value: 1)
//		
//		var gotValue = false
//		
//		promise.onNil() {
//			gotValue = true
//		}
//		
//		XCTAssert(gotValue == false)
//	}
}

class ForbindResultPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = Promise<Result<Int>>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue = true
		}
		
		promise.setValue(.Ok(Box(1)))
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = Promise<Result<Int>>()
		
		var gotValue = false
		
		promise.setValue(.Ok(Box(1)))
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise = Promise(value: Result.Ok(Box(1)))
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == .Ok(Box(1)))
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = Promise<Result<Int>>()
		
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
		
		promise.setValue(.Ok(Box(1)))
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
	func testGetError() {
		let promise = Promise<Result<Int>>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == .Error(genericError))
			gotValue = true
		}
		
		promise.setValue(.Error(genericError))
		
		XCTAssert(gotValue)
	}
	
	func testEquals() {
		let promise1 = Promise<Result<Int>>()
		let promise2 = Promise<Result<Int>>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == .Ok(Box(true)))
			gotValue = true
		}
		
		promise1.setValue(.Ok(Box(1)))
		promise2.setValue(.Ok(Box(1)))
		
		XCTAssert(gotValue)
	}
	
	func testEqualsError() {
		let promise1 = Promise<Result<Int>>()
		let promise2 = Promise<Result<Int>>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			switch value {
			case .Error(let e): gotValue = true
			case _: XCTAssert(false)
			}
		}
		
		promise1.setValue(.Ok(Box(1)))
		promise2.setValue(.Error(genericError))
		
		XCTAssert(gotValue)
	}
	
	func testEqualsFalse() {
		let promise1 = Promise<Result<Int>>()
		let promise2 = Promise<Result<Int>>()
		
		let equals = (promise1 == promise2)
		
		var gotValue = false
		
		equals.getValue { value in
			XCTAssert(value == .Ok(Box(false)))
			gotValue = true
		}
		
		promise1.setValue(.Ok(Box(1)))
		promise2.setValue(.Ok(Box(2)))
		
		XCTAssert(gotValue)
	}
	
//	func testOnError() {
//		let promise = Promise<Result<Int>>()
//		
//		var gotValue = false
//		
//		promise.onError() { error in
//			XCTAssert(error == genericError)
//			gotValue = true
//		}
//		
//		promise.setError(genericError)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testOnErrorNoError() {
//		let promise = Promise<Result<Int>>()
//		
//		var gotValue = false
//		
//		promise.onError() { error in
//			gotValue = true
//		}
//		
//		promise.setValue(.Ok(Box(1)))
//		
//		XCTAssert(gotValue == false)
//	}
//	
//	func testOnSome() {
//		let promise = ResultPromise(value: .Ok(Box(1)))
//		
//		var gotValue = false
//		
//		promise.onOk() { value in
//			XCTAssert(value == 1)
//			gotValue = true
//		}
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testOnSomeNoValue() {
//		let promise = ResultPromise<Int>(value: .Error(genericError))
//		
//		var gotValue = false
//		
//		promise.onOk() { value in
//			gotValue = true
//		}
//		
//		XCTAssert(gotValue == false)
//	}
}
