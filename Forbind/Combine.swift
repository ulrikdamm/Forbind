//
//  Combine.swift
//  BindTest
//
//  Created by Ulrik Damm on 26/02/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation

// A combine is a way to combine two values into a tuple. Like with bind, the
// difference being that it can validate and fail early if any of the types
// are in an invalid state. This is useful if you want to pass two values to
// a function, but only if both of the values are valid. The combine will take,
// for example, two optional values, and only if none of them are nil, it will
// create the tuple with two non-optional values. If any of them are nil, the
// whole result will be nil.
//
// Let's say you have two integers a and b, and you want to add them. That's
// easy, you just use the + operator. Well, what if one of them is optional?
// Now you need an if-let, and that's often annoying. Combining these two values
// with ++, you will get an optional tuple of two non-optional values, that you
// can then pass to the + operator (for example with a => bind), like this:
// 
// a ++ b => (+)
// 
// This will result in an optional integer, which will be nil if either a or b
// was nil.
// 
// Combines works with all values that bind works with. This file defines all
// combine functions between all the supported types. Combine also works with
// different types for each parameter, so you can for example combine an
// optional and a promise, and the result will be an OptionalPromise.
// 
// If you try to bind two Results, and both are in an error state, the result
// will be an NSError in the dk.ufd.Forbind domain, which contains each error.

public struct CombinedError : Error {
	let error1 : Error
	let error2 : Error
	
	public init(_ error1 : Error, _ error2 : Error) {
		self.error1 = error1
		self.error2 = error2
	}
}

//private let combinedError1Key = "dk.ufd.Bind.combineError1"
//private let combinedError2Key = "dk.ufd.Bind.combineError2"
//
//extension NSError {
//	class func combinedError(error1 : NSError, error2 : NSError) -> NSError {
//		if error1 == error2 {
//			return error1
//		}
//		
//		let userInfo = [
//			NSLocalizedDescriptionKey: "\(error1.localizedDescription), \(error2.localizedDescription)",
//			combinedError1Key: error1,
//			combinedError2Key: error2
//		]
//		
//		return NSError(domain: bindErrorDomain, code: bindErrors.CombinedError.rawValue, userInfo: userInfo)
//	}
//	
//	public var combineErrorLeft : NSError? { return userInfo[combinedError1Key] as? NSError }
//	public var combineErrorRight : NSError? { return userInfo[combinedError2Key] as? NSError }
//}

private func inverse<T, U>(_ v : (T, U)) -> (U, T) {
	return (v.1, v.0)
}

infix operator ++ : AssignmentPrecedence


/// Combine for T


public func combine<T, U>(_ t : T, u : U) -> (T, U) {
	return (t, u)
}

public func ++<T, U>(t : T, u : U) -> (T, U) { return combine(t, u: u) }


public func combine<T, U>(_ t : T, u : U?) -> (T, U)? {
	return u => { (t, $0) }
}

public func ++<T, U>(t : T, u : U?) -> (T, U)? { return combine(t, u: u) }


public func combine<T, U>(_ t : T, u : Result<U>) -> Result<(T, U)> {
	switch u {
	case .ok(let value): return .ok((t, value))
	case .error(let error): return .error(error)
	}
}

public func ++<T, U>(t : T, u : Result<U>) -> Result<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : T, u : Promise<U>) -> Promise<(T, U)> {
	let promise = Promise<(T, U)>()
	
	u.getValue { value in
		promise.setValue((t, value))
	}
	
	return promise
}

public func ++<T, U>(t : T, u : Promise<U>) -> Promise<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : T, u : Promise<U?>) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : T, u : Promise<U?>) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : T, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : T, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


/// Combine for T?


public func combine<T, U>(_ t : T?, u : U) -> (T, U)? {
	return t => { t in (t, u) }
}

public func ++<T, U>(t : T?, u : U) -> (T, U)? { return combine(t, u: u) }


public func combine<T, U>(_ t : T?, u : U?) -> (T, U)? {
	return u => { u in t => { t in (t, u) } }
}

public func ++<T, U>(t : T?, u : U?) -> (T, U)? { return combine(t, u: u) }


public func combine<T, U>(_ t : T?, u : Result<U>) -> Result<(T, U)> {
	switch (u, t) {
	case (.error(let e1), nil): return .error(CombinedError(e1, NilError()))
	case (.error(let e1), _): return .error(e1)
	case (_, nil): return .error(NilError())
	case (.ok(let value1), .some(let value)): return .ok(value, value1)
	case _: fatalError("Not gonna happen")
	}
}

public func ++<T, U>(t : T?, u : Result<U>) -> Result<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : T?, u : Promise<U>) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	if let t = t {
		u.getValue { value in
			let v = t ++ value
			promise.setValue(v)
		}
	} else {
		promise.setValue(nil)
	}
	
	return promise
}

public func ++<T, U>(t : T?, u : Promise<U>) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : T?, u : Promise<U?>) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	if let t = t {
		u.getValue { promise.setValue(t ++ $0) }
	} else {
		promise.setValue(nil)
	}
	
	return promise
}

public func ++<T, U>(t : T?, u : Promise<U?>) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : T?, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : T?, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


/// Combine for Result<T>


public func combine<T, U>(_ t : Result<T>, u : U) -> Result<(T, U)> {
	switch (t, u) {
	case (.error(let e1), _): return .error(e1)
	case (.ok(let value1), let value): return .ok(value1, value)
	}
}

public func ++<T, U>(t : Result<T>, u : U) -> Result<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : Result<T>, u : U?) -> Result<(T, U)> {
	switch (t, u) {
	case (.error(let e1), nil): return .error(CombinedError(e1, NilError()))
	case (.error(let e1), _): return .error(e1)
	case (_, nil): return .error(NilError())
	case (.ok(let value1), .some(let value)): return .ok(value1, value)
	case _: fatalError("Not gonna happen")
	}
}

public func ++<T, U>(t : Result<T>, u : U?) -> Result<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : Result<T>, u : Result<U>) -> Result<(T, U)> {
	switch (t, u) {
	case (.error(let e1), .error(let e2)): return .error(CombinedError(e1, e2))
	case (.error(let e1), _): return .error(e1)
	case (_, .error(let e2)): return .error(e2)
	case (.ok(let value1), .ok(let value2)): return .ok(value1, value2)
	case _: fatalError("Not gonna happen")
	}
}

public func ++<T, U>(t : Result<T>, u : Result<U>) -> Result<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : Result<T>, u : Promise<U>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	switch t {
	case .error(let error):
		promise.setValue(.error(error))
	case .ok(let value1): 
		u.getValue { value2 in
			let v = (value1, value2)
			promise.setValue(.ok(v))
		}
	}
	
	return promise
}

public func ++<T, U>(t : Result<T>, u : Promise<U>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Result<T>, u : Promise<U?>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : Result<T>, u : Promise<U?>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Result<T>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : Result<T>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


/// Combine for Promise<T>


public func combine<T, U>(_ t : Promise<T>, u : U) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	t.getValue {
		let v = $0 ++ u
		promise.setValue(v)
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : U) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T>, u : U?) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	if let u = u {
		t.getValue {
			let v = $0 ++ u
			promise.setValue(v)
		}
	} else {
		promise.setValue(nil)
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : U?) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T>, u : Result<U>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	switch u {
	case .error(let error): promise.setValue(.error(error))
	case .ok(let value): t.getValue { let v = ($0, value); promise.setValue(.ok(v)) }
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : Result<U>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T>, u : Promise<U>) -> Promise<(T, U)> {
	let promise = Promise<(T, U)>()
	
	t.getValue { t in
		u.getValue { u in
			let v = (t, u)
			promise.setValue(v)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : Promise<U>) -> Promise<(T, U)> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T>, u : Promise<U?>) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	u.getValue { u in
		if let u = u {
			t.getValue { t in
				let v = t ++ u
				promise.setValue(v)
			}
		} else {
			promise.setValue(nil)
		}
	}
	return promise
}

public func ++<T, U>(t : Promise<T>, u : Promise<U?>) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	u.getValue { u in
		switch u {
		case .error(let error):
			promise.setValue(.error(error))
		case .ok(let value):
			t.getValue { t in
				let v = (t, value)
				promise.setValue(.ok(v))
			}
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


/// Combine for Promise<T?>


public func combine<T, U>(_ t : Promise<T?>, u : U) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	t.getValue { value in
		if let value = value {
			let v = value ++ u
			promise.setValue(v)
		} else {
			promise.setValue(nil)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T?>, u : U) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T?>, u : U?) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	if let u = u {
		t.getValue { promise.setValue($0 ++ u) }
	} else {
		promise.setValue(nil)
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T?>, u : U?) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T?>, u : Result<U>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	switch u {
	case .error(let error):
		promise.setValue(.error(error))
	case .ok(let value):
		t.getValue { t in
			if let t = t {
				let v = (t, value)
				promise.setValue(.ok(v))
			} else {
				promise.setValue(.error(NilError()))
			}
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T?>, u : Result<U>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T?>, u : Promise<U>) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T?>, u : Promise<U>) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T?>, u : Promise<U?>) -> Promise<(T, U)?> {
	let promise = Promise<(T, U)?>()
	u.getValue { u in
		if let u = u {
			t.getValue { t in
				promise.setValue(t ++ u)
			}
		} else {
			promise.setValue(nil)
		}
	}
	return promise
}

public func ++<T, U>(t : Promise<T?>, u : Promise<U?>) -> Promise<(T, U)?> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<T?>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	u.getValue { u in
		switch u {
		case .error(let error):
			promise.setValue(.error(error))
		case .ok(let value):
			t.getValue { t in
				if let t = t {
					let v = (t, value)
					promise.setValue(.ok(v))
				} else {
					promise.setValue(.error(NilError()))
				}
			}
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T?>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


/// Combine for Promise<Result<T>>


public func combine<T, U>(_ t : Promise<Result<T>>, u : U) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	t.getValue { promise.setValue($0 ++ u) }
	return promise
}

public func ++<T, U>(t : Promise<Result<T>>, u : U) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<Result<T>>, u : U?) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	if let u = u {
		t.getValue { promise.setValue($0 ++ u) }
	} else {
		promise.setValue(.error(NilError()))
	}
	
	return promise
}

public func ++<T, U>(t : Promise<Result<T>>, u : U?) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<Result<T>>, u : Result<U>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	switch u {
	case .error(let error): promise.setValue(.error(error))
	case .ok(_): t.getValue { t in promise.setValue(t ++ u) }
	}
	
	return promise
}

public func ++<T, U>(t : Promise<Result<T>>, u : Result<U>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<Result<T>>, u : Promise<U>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<Result<T>>, u : Promise<U>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<Result<T>>, u : Promise<U?>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<Result<T>>, u : Promise<U?>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }


public func combine<T, U>(_ t : Promise<Result<T>>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> {
	let promise = Promise<Result<(T, U)>>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<Result<T>>, u : Promise<Result<U>>) -> Promise<Result<(T, U)>> { return combine(t, u: u) }

