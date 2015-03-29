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

private let combinedError1Key = "dk.ufd.Bind.combineError1"
private let combinedError2Key = "dk.ufd.Bind.combineError2"

extension NSError {
	class func combinedError(error1 : NSError, error2 : NSError) -> NSError {
		let userInfo = [
			NSLocalizedDescriptionKey: "\(error1.localizedDescription), \(error2.localizedDescription)",
			combinedError1Key: error1,
			combinedError2Key: error2
		]
		
		return NSError(domain: bindErrorDomain, code: bindErrors.CombinedError.rawValue, userInfo: userInfo)
	}
}

private func inverse<T, U>(v : (T, U)) -> (U, T) {
	return (v.1, v.0)
}

infix operator ++ {
associativity left
}


/// Combine for T


public func combine<T, U>(t : T, u : U) -> (T, U) {
	return (t, u)
}

public func ++<T, U>(t : T, u : U) -> (T, U) { return combine(t, u) }


public func combine<T, U>(t : T, u : U?) -> (T, U)? {
	return u => { (t, $0) }
}

public func ++<T, U>(t : T, u : U?) -> (T, U)? { return combine(t, u) }


public func combine<T, U>(t : T, u : Result<U>) -> Result<(T, U)> {
	switch u {
	case .Ok(let box): return .Ok(Box((t, box.value)))
	case .Error(let error): return .Error(error)
	}
}

public func ++<T, U>(t : T, u : Result<U>) -> Result<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : T, u : Promise<U>) -> Promise<(T, U)> {
	let promise = Promise<(T, U)>()
	
	u.getValue { value in
		let v = (t, value)
		promise.setValue(v)
	}
	
	return promise
}

public func ++<T, U>(t : T, u : Promise<U>) -> Promise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : T, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : T, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : T, u : ResultPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : T, u : ResultPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


/// Combine for T?


public func combine<T, U>(t : T?, u : U) -> (T, U)? {
	return t => { t in (t, u) }
}

public func ++<T, U>(t : T?, u : U) -> (T, U)? { return combine(t, u) }


public func combine<T, U>(t : T?, u : U?) -> (T, U)? {
	return u => { u in t => { t in (t, u) } }
}

public func ++<T, U>(t : T?, u : U?) -> (T, U)? { return combine(t, u) }


public func combine<T, U>(t : T?, u : Result<U>) -> Result<(T, U)> {
	switch (u, t) {
	case (.Error(let e1), nil): return .Error(.combinedError(e1, error2: resultNilError))
	case (.Error(let e1), _): return .Error(e1)
	case (_, nil): return .Error(resultNilError)
	case (.Ok(let box1), .Some(let value)): return .Ok(Box(value, box1.value))
	case _: fatalError("Not gonna happen")
	}
}

public func ++<T, U>(t : T?, u : Result<U>) -> Result<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : T?, u : Promise<U>) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	if let t = t {
		u.getValue { value in
			let v = t ++ value
			promise.setSomeValue(v)
		}
	} else {
		promise.setNil()
	}
	
	return promise
}

public func ++<T, U>(t : T?, u : Promise<U>) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : T?, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	if let t = t {
		u.getValue { promise.setValue(t ++ $0) }
	} else {
		promise.setNil()
	}
	
	return promise
}

public func ++<T, U>(t : T?, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : T?, u : ResultPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : T?, u : ResultPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


/// Combine for Result<T>


public func combine<T, U>(t : Result<T>, u : U) -> Result<(T, U)> {
	switch (t, u) {
	case (.Error(let e1), _): return .Error(e1)
	case (.Ok(let box1), let value): return .Ok(Box(box1.value, value))
	}
}

public func ++<T, U>(t : Result<T>, u : U) -> Result<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Result<T>, u : U?) -> Result<(T, U)> {
	switch (t, u) {
	case (.Error(let e1), nil): return .Error(.combinedError(e1, error2: resultNilError))
	case (.Error(let e1), _): return .Error(e1)
	case (_, nil): return .Error(resultNilError)
	case (.Ok(let box1), .Some(let value)): return .Ok(Box(box1.value, value))
	case _: fatalError("Not gonna happen")
	}
}

public func ++<T, U>(t : Result<T>, u : U?) -> Result<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Result<T>, u : Result<U>) -> Result<(T, U)> {
	switch (t, u) {
	case (.Error(let e1), .Error(let e2)): return .Error(.combinedError(e1, error2: e2))
	case (.Error(let e1), _): return .Error(e1)
	case (_, .Error(let e2)): return .Error(e2)
	case (.Ok(let box1), .Ok(let box2)): return .Ok(Box(box1.value, box2.value))
	case _: fatalError("Not gonna happen")
	}
}

public func ++<T, U>(t : Result<T>, u : Result<U>) -> Result<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Result<T>, u : Promise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	switch t {
	case .Error(let error): promise.setError(error)
	case .Ok(let box): 
		u.getValue { value in
			let v = (box.value, value)
			promise.setOkValue(v)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Result<T>, u : Promise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Result<T>, u : OptionalPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : Result<T>, u : OptionalPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Result<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	u.getValue { promise.setValue(t ++ $0) }
	return promise
}

public func ++<T, U>(t : Result<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


/// Combine for Promise<T>


public func combine<T, U>(t : Promise<T>, u : U) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	t.getValue {
		let v = $0 ++ u
		promise.setSomeValue(v)
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : U) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Promise<T>, u : U?) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	if let u = u {
		t.getValue {
			let v = $0 ++ u
			promise.setSomeValue(v)
		}
	} else {
		promise.setNil()
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : U?) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Promise<T>, u : Result<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	switch u {
	case .Error(let error): promise.setError(error)
	case .Ok(let box): t.getValue { let a = ($0, box.value); promise.setOkValue(a) }
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : Result<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Promise<T>, u : Promise<U>) -> Promise<(T, U)> {
	let promise = Promise<(T, U)>()
	
	t.getValue { t in
		u.getValue { u in
			let v = (t, u)
			promise.setValue(v)
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : Promise<U>) -> Promise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Promise<T>, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	u.getValue { u in
		if let u = u {
			t.getValue { t in
				let v = t ++ u
				promise.setSomeValue(v)
			}
		} else {
			promise.setNil()
		}
	}
	return promise
}

public func ++<T, U>(t : Promise<T>, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : Promise<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	u.getValue { u in
		switch u {
		case .Error(let error): promise.setError(error)
		case .Ok(let box):
			t.getValue { t in
				let v = (t, box.value)
				promise.setOkValue(v)
			}
		}
	}
	
	return promise
}

public func ++<T, U>(t : Promise<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


/// Combine for OptionalPromise<T>


public func combine<T, U>(t : OptionalPromise<T>, u : U) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	t.getValue { value in
		if let value = value {
			let v = value ++ u
			promise.setSomeValue(v)
		} else {
			promise.setNil()
		}
	}
	
	return promise
}

public func ++<T, U>(t : OptionalPromise<T>, u : U) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : OptionalPromise<T>, u : U?) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	if let u = u {
		t.getValue { promise.setValue($0 ++ u) }
	} else {
		promise.setNil()
	}
	
	return promise
}

public func ++<T, U>(t : OptionalPromise<T>, u : U?) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : OptionalPromise<T>, u : Result<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	switch u {
	case .Error(let error): promise.setError(error)
	case .Ok(let box):
		t.getValue { t in
			if let t = t {
				promise.setOkValue((t, box.value))
			} else {
				promise.setError(resultNilError)
			}
		}
	}
	
	return promise
}

public func ++<T, U>(t : OptionalPromise<T>, u : Result<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : OptionalPromise<T>, u : Promise<U>) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : OptionalPromise<T>, u : Promise<U>) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : OptionalPromise<T>, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> {
	let promise = OptionalPromise<(T, U)>()
	u.getValue { u in
		if let u = u {
			t.getValue { t in
				promise.setValue(t ++ u)
			}
		} else {
			promise.setNil()
		}
	}
	return promise
}

public func ++<T, U>(t : OptionalPromise<T>, u : OptionalPromise<U>) -> OptionalPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : OptionalPromise<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	u.getValue { u in
		switch u {
		case .Error(let error): promise.setError(error)
		case .Ok(let box):
			t.getValue { t in
				if let t = t {
					let v = (t, box.value)
					promise.setOkValue(v)
				} else {
					promise.setError(resultNilError)
				}
			}
		}
	}
	
	return promise
}

public func ++<T, U>(t : OptionalPromise<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


/// Combine for ResultPromise<T>


public func combine<T, U>(t : ResultPromise<T>, u : U) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	t.getValue { promise.setValue($0 ++ u) }
	
	return promise
}

public func ++<T, U>(t : ResultPromise<T>, u : U) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : ResultPromise<T>, u : U?) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	if let u = u {
		t.getValue { promise.setValue($0 ++ u) }
	} else {
		promise.setError(resultNilError)
	}
	
	return promise
}

public func ++<T, U>(t : ResultPromise<T>, u : U?) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : ResultPromise<T>, u : Result<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	switch u {
	case .Error(let error): promise.setError(error)
	case .Ok(let box): t.getValue { t in promise.setValue(t ++ u) }
	}
	
	return promise
}

public func ++<T, U>(t : ResultPromise<T>, u : Result<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : ResultPromise<T>, u : Promise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : ResultPromise<T>, u : Promise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : ResultPromise<T>, u : OptionalPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : ResultPromise<T>, u : OptionalPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }


public func combine<T, U>(t : ResultPromise<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> {
	let promise = ResultPromise<(T, U)>()
	
	t.getValue { t in
		u.getValue { u in
			promise.setValue(t ++ u)
		}
	}
	
	return promise
}

public func ++<T, U>(t : ResultPromise<T>, u : ResultPromise<U>) -> ResultPromise<(T, U)> { return combine(t, u) }

