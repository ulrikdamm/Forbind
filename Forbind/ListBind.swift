//
//  ListBind.swift
//  Forbind
//
//  Created by Ulrik Damm on 07/06/15.
//
//

import Foundation

// Basic binds

public func bind<T, U>(from : [T], to : T -> U) -> [U] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T], rhs : T -> U) -> [U] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [T?], to : T -> U) -> [U?] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T?], rhs : T -> U) -> [U?] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Result<T>], to : T -> U) -> [Result<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Result<T>], rhs : T -> U) -> [Result<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T>], to : T -> U) -> [Promise<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T>], rhs : T -> U) -> [Promise<U>] {
	return bind(lhs, rhs)
}

public func bind2<T, U>(lhs : [Promise<T>], rhs : T -> U) -> [Promise<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T?>], to : T -> U) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T?>], rhs : T -> U) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<Result<T>>], to : T -> U) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<Result<T>>], rhs : T -> U) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


// Bind to Optional


public func bind<T, U>(from : [T], to : T -> U?) -> [U?] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T], rhs : T -> U?) -> [U?] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [T?], to : T -> U?) -> [U?] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T?], rhs : T -> U?) -> [U?] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Result<T>], to : T -> U?) -> [Result<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Result<T>], rhs : T -> U?) -> [Result<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T>], to : T -> U?) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T>], rhs : T -> U?) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T?>], to : T -> U?) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T?>], rhs : T -> U?) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<Result<T>>], to : T -> U?) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<Result<T>>], rhs : T -> U?) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


// Bind to Result


public func bind<T, U>(from : [T], to : T -> Result<U>) -> [Result<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T], rhs : T -> Result<U>) -> [Result<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [T?], to : T -> Result<U>) -> [Result<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T?], rhs : T -> Result<U>) -> [Result<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Result<T>], to : T -> Result<U>) -> [Result<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Result<T>], rhs : T -> Result<U>) -> [Result<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T>], to : T -> Result<U>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T>], rhs : T -> Result<U>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T?>], to : T -> Result<U>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T?>], rhs : T -> Result<U>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<Result<T>>], to : T -> Result<U>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<Result<T>>], rhs : T -> Result<U>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


// Bind to Promise


public func bind<T, U>(from : [T], to : T -> Promise<U>) -> [Promise<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T], rhs : T -> Promise<U>) -> [Promise<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [T?], to : T -> Promise<U>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T?], rhs : T -> Promise<U>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Result<T>], to : T -> Promise<U>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Result<T>], rhs : T -> Promise<U>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T>], to : T -> Promise<U>) -> [Promise<U>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T>], rhs : T -> Promise<U>) -> [Promise<U>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T?>], to : T -> Promise<U>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T?>], rhs : T -> Promise<U>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<Result<T>>], to : T -> Promise<U>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<Result<T>>], rhs : T -> Promise<U>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


// Bind to OptionalPromise


public func bind<T, U>(from : [T], to : T -> Promise<U?>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T], rhs : T -> Promise<U?>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [T?], to : T -> Promise<U?>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T?], rhs : T -> Promise<U?>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Result<T>], to : T -> Promise<U?>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Result<T>], rhs : T -> Promise<U?>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}

public func bind<T, U>(from : [Promise<T>], to : T -> Promise<U?>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T>], rhs : T -> Promise<U?>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T?>], to : T -> Promise<U?>) -> [Promise<U?>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T?>], rhs : T -> Promise<U?>) -> [Promise<U?>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<Result<T>>], to : T -> Promise<U?>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<Result<T>>], rhs : T -> Promise<U?>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


// Bind to ResultPromise


public func bind<T, U>(from : [T], to : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T], rhs : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [T?], to : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [T?], rhs : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Result<T>], to : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Result<T>], rhs : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T>], to : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T>], rhs : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<T?>], to : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<T?>], rhs : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}


public func bind<T, U>(from : [Promise<Result<T>>], to : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return map(from) { $0 => to }
}

public func =><T, U>(lhs : [Promise<Result<T>>], rhs : T -> Promise<Result<U>>) -> [Promise<Result<U>>] {
	return bind(lhs, rhs)
}
