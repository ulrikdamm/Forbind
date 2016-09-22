//
//  Result.swift
//  BindTest
//
//  Created by Ulrik Damm on 30/01/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation

public struct NilError : Error {
	public init() {}
}

public enum Result<T> {
	case ok(T)
	case error(Error)
	
	public init(_ value : T) {
		self = .ok(value)
	}
	
	public init(_ error : Error) {
		self = .error(error)
	}
	
	init<U>(from : U, _ transform : (U) throws -> T) {
		do {
			self = .ok(try transform(from))
		} catch let error {
			self = .error(error)
		}
	}
	
	public var errorValue : Error? {
		switch self {
		case .error(let e): return e
		case _: return nil
		}
	}
	
	public var okValue : T? {
		switch self {
		case .ok(let value): return value
		case _: return nil
		}
	}
	
	public func value() throws -> T {
		switch self {
		case .error(let e): throw e
		case .ok(let value): return value
		}
	}
}

//public func ==<T : Equatable>(lhs : Result<T>, rhs : Result<T>) -> Bool {
//	switch (lhs, rhs) {
//	case (.Ok(let l), .Ok(let r)) where l == r: return true
//	case (.Error(let el), .Error(let er)) where el == er: return true
//	case _: return false
//	}
//}

//public func !=<T : Equatable>(lhs : Result<T>, rhs : Result<T>) -> Bool {
//	return !(lhs == rhs)
//}

extension Result : CustomStringConvertible {
	public var description : String {
		switch self {
		case .ok(let value): return "Result.Ok(\(value))"
		case .error(let error): return "Result.Error(\(error))"
		}
	}
}

