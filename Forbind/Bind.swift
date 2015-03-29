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
// T, T?, Result<T>, Promise<T>, OptionalPromise<T>, ResultPromise<T>


infix operator => {
associativity left
}

// Basic binds


public func bind<T, U>(from : T, to : T -> U) -> U {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> U) -> U {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : T?, to : T -> U) -> U? {
	if let from = from {
		return to(from)
	} else {
		return nil
	}
}

public func =><T, U>(lhs : T?, rhs : T -> U) -> U? {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> U) -> Result<U> {
	switch from {
	case .Ok(let box):
		return .Ok(Box(to(box.value)))
	case .Error(let error):
		return .Error(error)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> U) -> Result<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> U) -> Promise<U> {
	let promise = Promise<U>()
	
	from.getValue { value in
		promise.setValue(to(value))
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> U) -> Promise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : OptionalPromise<T>, to : T -> U) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	from.getValue { value in
		if let value = value {
			promise.setSomeValue(to(value))
		} else {
			promise.setNil()
		}
	}
	
	return promise
}

public func =><T, U>(lhs : OptionalPromise<T>, rhs : T -> U) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : ResultPromise<T>, to : T -> U) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Ok(let box):
			promise.setOkValue(to(box.value))
		case .Error(let error):
			promise.setError(error)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : ResultPromise<T>, rhs : T -> U) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


// Bind to Optional


public func bind<T, U>(from : T, to : T -> U?) -> U? {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> U?) -> U? {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : T?, to : T -> U?) -> U? {
	if let from = from {
		return to(from)
	} else {
		return nil
	}
}

public func =><T, U>(lhs : T?, rhs : T -> U?) -> U? {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> U?) -> Result<U> {
	switch from {
	case .Ok(let box):
		if let v = to(box.value) {
			return .Ok(Box(v))
		} else {
			return .Error(resultNilError)
		}
	case .Error(let error):
		return .Error(error)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> U?) -> Result<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> U?) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	from.getValue { value in
		if let v = to(value) {
			promise.setSomeValue(v)
		} else {
			promise.setNil()
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> U?) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : OptionalPromise<T>, to : T -> U?) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	from.getValue { value in
		if let value = value {
			if let v = to(value) {
				promise.setSomeValue(v)
			} else {
				promise.setNil()
			}
		} else {
			promise.setNil()
		}
	}
	
	return promise
}

public func =><T, U>(lhs : OptionalPromise<T>, rhs : T -> U?) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : ResultPromise<T>, to : T -> U?) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Ok(let box):
			if let v = to(box.value) {
				promise.setValue(.Ok(Box(v)))
			} else {
				promise.setValue(.Error(resultNilError))
			}
		case .Error(let error):
			return promise.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : ResultPromise<T>, rhs : T -> U?) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


// Bind to Result


public func bind<T, U>(from : T, to : T -> Result<U>) -> Result<U> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> Result<U>) -> Result<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : T?, to : T -> Result<U>) -> Result<U> {
	if let from = from {
		return to(from)
	} else {
		return .Error(resultNilError)
	}
}

public func =><T, U>(lhs : T?, rhs : T -> Result<U>) -> Result<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> Result<U>) -> Result<U> {
	switch from {
	case .Ok(let box):
		return to(box.value)
	case .Error(let error):
		return .Error(error)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> Result<U>) -> Result<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> Result<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		promise.setValue(to(value))
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> Result<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : OptionalPromise<T>, to : T -> Result<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		if let value = value {
			promise.setValue(to(value))
		} else {
			promise.setError(resultNilError)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : OptionalPromise<T>, rhs : T -> Result<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : ResultPromise<T>, to : T -> Result<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Ok(let box):
			promise.setValue(to(box.value))
		case .Error(let error):
			promise.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : ResultPromise<T>, rhs : T -> Result<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


// Bind to Promise


public func bind<T, U>(from : T, to : T -> Promise<U>) -> Promise<U> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> Promise<U>) -> Promise<U> {
	return rhs(lhs)
}


public func bind<T, U>(from : T?, to : T -> Promise<U>) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	if let from = from {
		to(from).getValue { value in
			promise.setSomeValue(value)
		}
	} else {
		promise.setNil()
	}
	
	return promise
}

public func =><T, U>(lhs : T?, rhs : T -> Promise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> Promise<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	switch from {
	case .Ok(let box):
		to(box.value).getValue { value in
			promise.setOkValue(value)
		}
	case .Error(let error):
		promise.setError(error)
	}
	
	return promise
}

public func =><T, U>(lhs : Result<T>, rhs : T -> Promise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> Promise<U>) -> Promise<U> {
	let promise = Promise<U>()
	
	from.getValue { value in
		to(value).getValue { value in
			promise.setValue(value)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> Promise<U>) -> Promise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : OptionalPromise<T>, to : T -> Promise<U>) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Some(let v):
			to(v).getValue { value in
				promise.setSomeValue(value)
			}
		case .None:
			promise.setNil()
		}
	}
	
	return promise
}

public func =><T, U>(lhs : OptionalPromise<T>, rhs : T -> Promise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : ResultPromise<T>, to : T -> Promise<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Ok(let box):
			to(box.value).getValue { value in
				promise.setOkValue(value)
			}
		case .Error(let error):
			promise.setError(error)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : ResultPromise<T>, rhs : T -> Promise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


// Bind to OptionalPromise


public func bind<T, U>(from : T, to : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : T?, to : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	if let from = from {
		return to(from)
	} else {
		return OptionalPromise(value: nil)
	}
}

public func =><T, U>(lhs : T?, rhs : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	switch from {
	case .Ok(let box):
		return to(box.value)
	case .Error(_):
		return OptionalPromise(value: nil)
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}

public func bind<T, U>(from : Promise<T>, to : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	from.getValue { value in
		to(value).getValue { value in
			promise.setValue(value)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : OptionalPromise<T>, to : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	let promise = OptionalPromise<U>()
	
	from.getValue { value in
		if let v = value {
			to(v).getValue { value in
				if let value = value {
					promise.setSomeValue(value)
				} else {
					promise.setNil()
				}
			}
		} else {
			promise.setNil()
		}
	}
	
	return promise
}

public func =><T, U>(lhs : OptionalPromise<T>, rhs : T -> OptionalPromise<U>) -> OptionalPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : ResultPromise<T>, to : T -> OptionalPromise<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Ok(let box):
			to(box.value).getValue { value in
				if let value = value {
					promise.setOkValue(value)
				} else {
					promise.setError(resultNilError)
				}
			}
		case .Error(let error):
			promise.setError(error)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : ResultPromise<T>, rhs : T -> OptionalPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


// Bind to ResultPromise


public func bind<T, U>(from : T, to : T -> ResultPromise<U>) -> ResultPromise<U> {
	return to(from)
}

public func =><T, U>(lhs : T, rhs : T -> ResultPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : T?, to : T -> ResultPromise<U>) -> ResultPromise<U> {
	if let from = from {
		return to(from)
	} else {
		return ResultPromise(value: .Error(resultNilError))
	}
}

public func =><T, U>(lhs : T?, rhs : T -> ResultPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Result<T>, to : T -> ResultPromise<U>) -> ResultPromise<U> {
	switch from {
	case .Ok(let box):
		return to(box.value)
	case .Error(let error):
		return ResultPromise(value: .Error(error))
	}
}

public func =><T, U>(lhs : Result<T>, rhs : T -> ResultPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : Promise<T>, to : T -> ResultPromise<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		to(value).getValue { value in
			promise.setValue(value)
		}
	}
	
	return promise
}

public func =><T, U>(lhs : Promise<T>, rhs : T -> ResultPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : OptionalPromise<T>, to : T -> ResultPromise<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		if let value = value {
			to(value).getValue { value in
				promise.setValue(value)
			}
		} else {
			promise.setValue(.Error(resultNilError))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : OptionalPromise<T>, rhs : T -> ResultPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : ResultPromise<T>, to : T -> ResultPromise<U>) -> ResultPromise<U> {
	let promise = ResultPromise<U>()
	
	from.getValue { value in
		switch value {
		case .Ok(let box):
			to(box.value).getValue { value in
				promise.setValue(value)
			}
		case .Error(let error):
			promise.setValue(.Error(error))
		}
	}
	
	return promise
}

public func =><T, U>(lhs : ResultPromise<T>, rhs : T -> ResultPromise<U>) -> ResultPromise<U> {
	return bind(lhs, rhs)
}
