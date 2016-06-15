//
//  ForbindExtensionsTests.swift
//  ForbindExtensionsTests
//
//  Created by Ulrik Damm on 29/03/15.
//
//

import UIKit
import XCTest
import Forbind
import ForbindExtensions

class ForbindNSURLSessionExtensionsTests : XCTestCase {
	func testCancellation() {
		let session = URLSession(configuration: .default())
		
		var result : TaskPromise? = URL(string: "http://ufd.dk") => session.dataTask
		let task = result?.task
		
		XCTAssert(task?.state != URLSessionTask.State.canceling)
		
		result = nil
		
		XCTAssert(task?.state == URLSessionTask.State.canceling)
	}
}

class ForbindDispatchTests : XCTestCase {
	func testDispatch() {
		let promise = Promise<String>()
		
		let promise2 = dispatchAsync(promise, queue: DispatchQueue.main)
		
		var finished = false
		
		promise2.getValue { value in
			XCTAssert(value == "Test!")
			XCTAssert(Thread.current().isMainThread)
			finished = true
		}
		
		DispatchQueue.global().async {
			promise.setValue("Test!")
		}
		
		RunLoop.main().run(until: Date().addingTimeInterval(1))
		XCTAssert(finished)
	}
}
