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

extension Result : Printable {
	public var description : String {
		switch self {
		case .Ok(let box): return "Result.Ok(\(box.value))"
		case .Error(let error): return "Result.Error(\(error))"
		}
	}
}


private enum PromiseState<T> {
	case NoValue
	case Value(Box<T>)
}

public class Promise<T> {
	public init(value : T? = nil) {
		value => setValue
	}
	
	private var _value : PromiseState<T> = .NoValue
	
	func setValue(value : T) {
		_value = PromiseState.Value(Box(value))
		notifyListeners()
	}
	
	public var value : T? {
		get {
			switch _value {
			case .NoValue: return nil
			case .Value(let box): return box.value
			}
		}
	}
	
	private var listeners : [T -> Void] = []
	
	public func getValue(callback : T -> Void) {
		if let value = value {
			callback(value)
		} else {
			listeners.append(callback)
		}
	}
	
	private func notifyListeners() {
		switch _value {
		case .NoValue: break
		case .Value(let box): 
			for callback in listeners {
				callback(box.value)
			}
		}
		
		listeners = []
	}
}

public func ==<T : Equatable>(lhs : Promise<T>, rhs : Promise<T>) -> Promise<Bool> {
	return (lhs ++ rhs) => { $0 == $1 }
}

public func ==<T : Equatable>(lhs : Promise<T?>, rhs : Promise<T?>) -> Promise<Bool?> {
	return (lhs ++ rhs) => { $0 == $1 }
}

public func ==<T : Equatable>(lhs : Promise<Result<T>>, rhs : Promise<Result<T>>) -> Promise<Result<Bool>> {
	return (lhs ++ rhs) => { $0 == $1 }
}

extension Promise : Printable {
	public var description : String {
		if let value = value {
			return "Promise(\(value))"
		} else {
			return "Promise(\(T.self))"
		}
	}
}
