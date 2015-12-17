//
//  Result.swift
//  BindTest
//
//  Created by Ulrik Damm on 30/01/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation

public struct NilError : ErrorType {}

public enum Result<T> {
	case Ok(T)
	case Error(ErrorType)
	
	public init(_ value : T) {
		self = .Ok(value)
	}
	
	public init(_ error : ErrorType) {
		self = .Error(error)
	}
	
	init<U>(from : U, _ transform : U throws -> T) {
		do {
			self = .Ok(try transform(from))
		} catch let error {
			self = .Error(error)
		}
	}
	
	public var errorValue : ErrorType? {
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
	
	public func value() throws -> T {
		switch self {
		case .Error(let e): throw e
		case .Ok(let value): return value
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
		case .Ok(let value): return "Result.Ok(\(value))"
		case .Error(let error): return "Result.Error(\(error))"
		}
	}
}

