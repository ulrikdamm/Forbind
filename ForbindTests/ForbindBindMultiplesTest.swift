//
//  ForbindBindMultiplesTest.swift
//  Forbind
//
//  Created by Ulrik Damm on 26/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import XCTest

/// Tests binding (=>) multiple expressions together, and quitting early if
/// something fails.
class ForbindBindMultiplesTest : XCTestCase {
	func testBindSecondCalled() {
		let inc : Int -> Int = { $0 + 1 }
		let stringify : Int -> String = { "\($0)" }
		
		let result = (1 => inc => stringify)
		
		XCTAssert(result == "2")
	}
	
	func testBindSecondNotCalled() {
		var function1Called = false
		var function2Called = false
		
		let nul : Int -> Int? = { _ in function1Called = true; return nil }
		let stringify : Int -> String = { function2Called = true; return "\($0)" }
		
		let result = (1 => nul => stringify)
		
		XCTAssert(function1Called)
		XCTAssert(function2Called == false)
		XCTAssert(result == nil)
	}
}
