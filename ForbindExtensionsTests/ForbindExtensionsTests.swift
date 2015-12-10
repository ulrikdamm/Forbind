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
		let session = NSURLSession(configuration: .defaultSessionConfiguration())
		
		var result : TaskPromise? = NSURL(string: "http://ufd.dk") => session.dataTask
		let task = result?.task
		
		XCTAssert(task?.state != NSURLSessionTaskState.Canceling)
		
		result = nil
		
		XCTAssert(task?.state == NSURLSessionTaskState.Canceling)
	}
}

class ForbindDispatchTests : XCTestCase {
	func testDispatch() {
		let promise = Promise<String>()
		
		let promise2 = dispatchAsync(promise, queue: dispatch_get_main_queue())
		
		var finished = false
		
		promise2.getValue { value in
			XCTAssert(value == "Test!")
			XCTAssert(NSThread.currentThread().isMainThread)
			finished = true
		}
		
		dispatch_async(dispatch_get_global_queue(0, 0)) {
			promise.setValue("Test!")
		}
		
		NSRunLoop.mainRunLoop().runUntilDate(NSDate().dateByAddingTimeInterval(1))
		XCTAssert(finished)
	}
}
