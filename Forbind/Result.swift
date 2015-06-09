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

public enum Result<T> {
	case Ok(T)
	case Error(NSError)
	
	public init(_ value : T) {
		self = .Ok(value)
	}
	
	public init(_ error : NSError) {
		self = .Error(error)
	}
	
	public var errorValue : NSError? {
		switch self {
		case .Error(let e): return e
		case _: return nil
		}
	}
	
	public var okValue : T? {
		switch self {
		case .Ok(let value): return value
		case _: return nil
		}
	}
}

public func ==<T : Equatable>(lhs : Result<T>, rhs : Result<T>) -> Bool {
	switch (lhs, rhs) {
	case (.Ok(let l), .Ok(let r)) where l == r: return true
	case (.Error(let el), .Error(let er)) where el == er: return true
	case _: return false
	}
}

public func !=<T : Equatable>(lhs : Result<T>, rhs : Result<T>) -> Bool {
	return !(lhs == rhs)
}

extension Result : CustomStringConvertible {
	public var description : String {
		switch self {
		case .Ok(let value): return "Result.Ok(\(value))"
		case .Error(let error): return "Result.Error(\(error))"
		}
	}
}

