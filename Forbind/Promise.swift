//
//  Promise.swift
//  Forbind
//
//  Created by Ulrik Damm on 06/06/15.
//
//

import Foundation

private enum PromiseState<T> {
	case NoValue
	case Value(T)
}

public class Promise<T> {
	public init(value : T? = nil) {
		value => setValue
	}
	
	private var _value : PromiseState<T> = .NoValue
	var previousPromise : AnyObject?
	
	public func setValue(value : T) {
		_value = PromiseState.Value(value)
		notifyListeners()
	}
	
	public var value : T? {
		get {
			switch _value {
			case .NoValue: return nil
			case .Value(let value): return value
			}
		}
	}
	
	private var listeners : [T -> Void] = []
	
	public func getValue(callback : T -> Void) {
		getValueWeak { value in
			self
			callback(value)
		}
	}
	
	public func getValueWeak(callback : T -> Void) {
		if let value = value {
			callback(value)
		} else {
			listeners.append(callback)
		}
	}
	
	private func notifyListeners() {
		switch _value {
		case .NoValue: break
		case .Value(let value):
			for callback in listeners {
				callback(value)
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

extension Promise : CustomStringConvertible {
	public var description : String {
		if let value = value {
			return "Promise(\(value))"
		} else {
			return "Promise(\(T.self))"
		}
	}
}

public func filterp<T>(source : [Promise<T>], includeElement : T -> Bool) -> Promise<[T]> {
	return reducep(source, initial: []) { all, this in includeElement(this) ? all + [this] : all }
}

public func reducep<T, U>(source : [Promise<T>], initial : U, combine : (U, T) -> U) -> Promise<U> {
	return source.reduce(Promise(value: initial)) { $0 ++ $1 => combine }
}
