//
//  Bind.swift
//  BindTest
//
//  Created by Ulrik Damm on 30/01/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation

// A bind chains a value to an expression, like a function call. The difference
// is that the bind can unpack a value before it's passed to the function.
// This can be unwrapping an optional, checking a result for errors, or even
// waiting for a promise to have a value. If the validation fails, the bind will
// quit early. This allows you to chain operations together, such as:
// 
// let result = getInput => sendNetworkRequest => parseJSON => parseResult
// 
// All of these operations might fail. If it does, the chain of expressions is
// ended early, and the result will be an error state. Before using the result
// in the end, you will have to unpack it.
// 
// Binds automatically upgrades to the required type. This means that if you
// bind a non-optional value to an optional value, the result will be an
// optional. It will even combine different types, so that if you bind a
// result type to a promise, the final value will be a ResultPromise.
// 
// If you bind an optional value to a result type, the final type will be
// Result. In that case, if the optional is nil, the final value will be a
// Result.Error with an NSError in the dk.ufd.Forbind domain.
// 
// This file specifies how each type binds to another type. You can bind the
// follow types:
// T, T?, Result<T>, Promise<T>, Promise<T?>, Promise<Result<T>>


infix operator => {
associativity left
}

// Basic binds

public func bind<T, U>(from : T, to : T -> U) -> U {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> U) -> U {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : T?, to : T -> U) -> U? {
	if let from = from {
		return to(from)
	} else {
		return nil
	}
}

public func =><T, U>(lhs : T?, rhs : T -> U) -> U? {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> U) -> Result<U> {
	switch from {
	case .Ok(let value):
		return .Ok(to(value))
	case .Error(let error):
		return .Error(error)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> U) -> Result<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> U) -> Promise<U> {
	let promise = Promise<U>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		promise?.setValue(to(value))
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> U) -> Promise<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T?>, to : T -> U) -> Promise<U?> {
	let promise = Promise<U?>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		if let value = value {
			promise?.setValue(to(value))
		} else {
			promise?.setValue(nil)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T?>, rhs : T -> U) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<Result<T>>, to : T -> U) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Ok(let value):
			promise?.setValue(.Ok(to(value)))
		case .Error(let error):
			promise?.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<Result<T>>, rhs : T -> U) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


// Bind to Optional


public func bind<T, U>(from : T, to : T -> U?) -> U? {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> U?) -> U? {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : T?, to : T -> U?) -> U? {
	if let from = from {
		return to(from)
	} else {
		return nil
	}
}

public func =><T, U>(lhs : T?, rhs : T -> U?) -> U? {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> U?) -> Result<U> {
	switch from {
	case .Ok(let value):
		if let v = to(value) {
			return .Ok(v)
		} else {
			return .Error(resultNilError)
		}
	case .Error(let error):
		return .Error(error)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> U?) -> Result<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> U?) -> Promise<U?> {
	let promise = Promise<U?>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		promise?.setValue(to(value))
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> U?) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T?>, to : T -> U?) -> Promise<U?> {
	let promise = Promise<U?>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		if let value = value {
			promise?.setValue(to(value))
		} else {
			promise?.setValue(nil)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T?>, rhs : T -> U?) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<Result<T>>, to : T -> U?) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Ok(let value):
			if let v = to(value) {
				promise?.setValue(.Ok(v))
			} else {
				promise?.setValue(.Error(resultNilError))
			}
		case .Error(let error):
			promise?.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<Result<T>>, rhs : T -> U?) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


// Bind to Result


public func bind<T, U>(from : T, to : T -> Result<U>) -> Result<U> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> Result<U>) -> Result<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : T?, to : T -> Result<U>) -> Result<U> {
	if let from = from {
		return to(from)
	} else {
		return .Error(resultNilError)
	}
}

public func =><T, U>(lhs : T?, rhs : T -> Result<U>) -> Result<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> Result<U>) -> Result<U> {
	switch from {
	case .Ok(let value):
		return to(value)
	case .Error(let error):
		return .Error(error)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> Result<U>) -> Result<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> Result<U>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		promise?.setValue(to(value))
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> Result<U>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T?>, to : T -> Result<U>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		if let value = value {
			promise?.setValue(to(value))
		} else {
			promise?.setValue(.Error(resultNilError))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T?>, rhs : T -> Result<U>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<Result<T>>, to : T -> Result<U>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Ok(let value):
			promise?.setValue(to(value))
		case .Error(let error):
			promise?.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<Result<T>>, rhs : T -> Result<U>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


// Bind to Promise


public func bind<T, U>(from : T, to : T -> Promise<U>) -> Promise<U> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> Promise<U>) -> Promise<U> {
	return rhs(lhs)
}


public func bind<T, U>(from : T?, to : T -> Promise<U>) -> Promise<U?> {
	let promise = Promise<U?>()
	
	if let from = from {
		let p = to(from)
		promise.previousPromise = p
		
		p.getValueWeak { [weak promise] value in
			promise?.setValue(value)
		}
	} else {
		promise.setValue(nil)
	}
	
	return promise
}

public func =><T, U>(lhs : T?, rhs : T -> Promise<U>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> Promise<U>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	
	switch from {
	case .Ok(let value):
		let p = to(value)
		promise.previousPromise = p
		
		p.getValueWeak { [weak promise] value in
			promise?.setValue(.Ok(value))
		}
	case .Error(let error):
		promise.setValue(.Error(error))
	}
	
	return promise
}

public func =><T, U>(lhs : Result<T>, rhs : T -> Promise<U>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> Promise<U>) -> Promise<U> {
	let promise = Promise<U>()
	promise.previousPromise = from
	
	from.getValueWeak { value in
		to(value).getValueWeak { [weak promise] value in
			promise?.setValue(value)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> Promise<U>) -> Promise<U> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T?>, to : T -> Promise<U>) -> Promise<U?> {
	let promise = Promise<U?>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Some(let v):
			to(v).getValueWeak { [weak promise] value in
				promise?.setValue(value)
			}
		case .None:
			promise?.setValue(nil)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T?>, rhs : T -> Promise<U>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<Result<T>>, to : T -> Promise<U>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Ok(let value):
			to(value).getValueWeak { [weak promise] value in
				promise?.setValue(.Ok(value))
			}
		case .Error(let error):
			promise?.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<Result<T>>, rhs : T -> Promise<U>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


// Bind to OptionalPromise


public func bind<T, U>(from : T, to : T -> Promise<U?>) -> Promise<U?> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> Promise<U?>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : T?, to : T -> Promise<U?>) -> Promise<U?> {
	if let from = from {
		return to(from)
	} else {
		return Promise(value: nil)
	}
}

public func =><T, U>(lhs : T?, rhs : T -> Promise<U?>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> Promise<U?>) -> Promise<U?> {
	switch from {
	case .Ok(let value):
		return to(value)
	case .Error(_):
		return Promise(value: nil)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> Promise<U?>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> Promise<U?>) -> Promise<U?> {
	let promise = Promise<U?>()
	promise.previousPromise = from
	
	from.getValueWeak { value in
		to(value).getValueWeak { [weak promise] value in
			promise?.setValue(value)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> Promise<U?>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T?>, to : T -> Promise<U?>) -> Promise<U?> {
	let promise = Promise<U?>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		if let v = value {
			to(v).getValueWeak { [weak promise] value in
				promise?.setValue(value)
			}
		} else {
			promise?.setValue(nil)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T?>, rhs : T -> Promise<U?>) -> Promise<U?> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<Result<T>>, to : T -> Promise<U?>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Ok(let value):
			to(value).getValueWeak { [weak promise] value in
				if let value = value {
					promise?.setValue(.Ok(value))
				} else {
					promise?.setValue(.Error(resultNilError))
				}
			}
		case .Error(let error):
			promise?.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<Result<T>>, rhs : T -> Promise<U?>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


// Bind to ResultPromise


public func bind<T, U>(from : T, to : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : T?, to : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	if let from = from {
		return to(from)
	} else {
		return Promise(value: .Error(resultNilError))
	}
}

public func =><T, U>(lhs : T?, rhs : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	switch from {
	case .Ok(let value):
		return to(value)
	case .Error(let error):
		return Promise(value: .Error(error))
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { value in
		to(value).getValueWeak { [weak promise] value in
			promise?.setValue(value)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<T?>, to : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		if let value = value {
			to(value).getValueWeak { [weak promise] value in
				promise?.setValue(value)
			}
		} else {
			promise?.setValue(.Error(resultNilError))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T?>, rhs : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}


public func bind<T, U>(from : Promise<Result<T>>, to : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	let promise = Promise<Result<U>>()
	promise.previousPromise = from
	
	from.getValueWeak { [weak promise] value in
		switch value {
		case .Ok(let value):
			to(value).getValueWeak { [weak promise] value in
				promise?.setValue(value)
			}
		case .Error(let error):
			promise?.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<Result<T>>, rhs : T -> Promise<Result<U>>) -> Promise<Result<U>> {
	return bind(lhs, to: rhs)
}
