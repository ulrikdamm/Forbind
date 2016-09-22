//
//  Promise.swift
//  Forbind
//
//  Created by Ulrik Damm on 06/06/15.
//
//

import Foundation

private enum PromiseState<T> {
	case noValue
	case value(T)
}

open class Promise<T> {
	public init(value : T? = nil) {
		value => setValue
	}
	
	public init(previousPromise : AnyObject) {
		self.previousPromise = previousPromise
	}
	
	fileprivate var _value : PromiseState<T> = .noValue
	var previousPromise : AnyObject?
	
	open func setValue(_ value : T) {
		_value = PromiseState.value(value)
		notifyListeners()
	}
	
	open var value : T? {
		get {
			switch _value {
			case .noValue: return nil
			case .value(let value): return value
			}
		}
	}
	
	fileprivate var listeners : [(T) -> Void] = []
	
	open func getValue(_ callback : @escaping (T) -> Void) {
		getValueWeak { value in
			let _ = self
			callback(value)
		}
	}
	
	open func getValueWeak(_ callback : @escaping (T) -> Void) {
		if let value = value {
			callback(value)
		} else {
			listeners.append(callback)
		}
	}
	
	fileprivate func notifyListeners() {
		switch _value {
		case .noValue: break
		case .value(let value):
			for callback in listeners {
				callback(value)
			}
		}
		
		listeners = []
	}
}

//public func ==<T : Equatable>(lhs : Promise<T>, rhs : Promise<T>) -> Promise<Bool> {
//	return (lhs ++ rhs) => { $0 == $1 }
//}
//
//public func ==<T : Equatable>(lhs : Promise<T?>, rhs : Promise<T?>) -> Promise<Bool?> {
//	return (lhs ++ rhs) => { $0 == $1 }
//}
//
//public func ==<T : Equatable>(lhs : Promise<Result<T>>, rhs : Promise<Result<T>>) -> Promise<Result<Bool>> {
//	return (lhs ++ rhs) => { $0 == $1 }
//}

extension Promise : CustomStringConvertible {
	public var description : String {
		if let value = value {
			return "Promise(\(value))"
		} else {
			return "Promise(\(T.self))"
		}
	}
}

//public func filterp<T>(_ source : [Promise<T>], includeElement : (T) -> Bool) -> Promise<[T]> {
//	return reducep(source, initial: []) { all, this in includeElement(this) ? all + [this] : all }
//}
//
//public func reducep<T, U>(_ source : [Promise<T>], initial : U, combine : (U, T) -> U) -> Promise<U> {
//	return source.reduce(Promise(value: initial)) { $0 ++ $1 => combine }
//}
