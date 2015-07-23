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
