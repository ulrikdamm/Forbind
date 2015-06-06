//
//  Result.swift
//  BindTest
//
//  Created by Ulrik Damm on 30/01/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation

let bindErrorDomain = "dk.ufd.Forbind"

enum bindErrors : Int {
	case CombinedError = 1
	case NilError = 2
}

let resultNilError = NSError(domain: bindErrorDomain, code: bindErrors.NilError.rawValue, userInfo: [NSLocalizedDescriptionKey: "Nil result"])

public class Box<T> {
	public let value : T
	
	public init(_ value : T) {
		self.value = value
	}
}

public enum Result<T> {
	case Ok(Box<T>)
	case Error(NSError)
	
	init(_ value : T) {
		self = .Ok(Box(value))
	}
	
	init(_ error : NSError) {
		self = .Error(error)
	}
}

public func ==<T : Equatable>(lhs : Result<T>, rhs : Result<T>) -> Bool {
	switch (lhs, rhs) {
	case (.Ok(let l), .Ok(let r)) where l.value == r.value: return true
	case (.Error(let el), .Error(let er)) where el == er: return true
	case _: return false
	}
}

public func !=<T : Equatable>(lhs : Result<T>, rhs : Result<T>) -> Bool {
	return !(lhs == rhs)
}

extension Result : Printable {
	public var description : String {
		switch self {
		case .Ok(let box): return "Result.Ok(\(box.value))"
		case .Error(let error): return "Result.Error(\(error))"
		}
	}
}

