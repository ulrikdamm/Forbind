//
//  dispatchExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 27/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import Forbind

// Dispatches to promises
// The idea behind these is that you can insert a dispatchAfter or dispatchAsync
// into your expression chain, like
// func1 => dispatchAsync(dispatch_get_main_queue()) => func2
// Unfortunately, Swift will only compile that for Optionals, doesn't work
// for Result or Promise. If you find what's wrong, please submit a pull request

public func dispatchAfter<T>(when : dispatch_time_t, queue : dispatch_queue_t)(value : T) -> Promise<T> {
	let promise = Promise<T>()
	dispatch_after(when, queue) {
		promise.setValue(value)
	}
	return promise
}

public func dispatchAsync<T>(queue : dispatch_queue_t)(value : T) -> Promise<T> {
	let promise = Promise<T>()
	dispatch_async(queue) {
		promise.setValue(value)
	}
	return promise
}
