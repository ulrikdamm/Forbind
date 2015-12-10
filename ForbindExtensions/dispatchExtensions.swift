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
// dispatchAsync(promise, queue: dispatch_get_main_queue()) => func1

public func dispatchAfter<T>(promise : Promise<T>, when : dispatch_time_t, queue : dispatch_queue_t) -> Promise<T> {
	let newpromise = Promise<T>(previousPromise: promise)
	
	promise.getValue { value in
		dispatch_after(when, queue) {
			newpromise.setValue(value)
		}
	}
	
	return newpromise
}

public func dispatchAsync<T>(promise : Promise<T>, queue : dispatch_queue_t) -> Promise<T> {
	let newpromise = Promise<T>(previousPromise: promise)
	
	promise.getValue { value in
		dispatch_async(queue) {
			newpromise.setValue(value)
		}
	}
	
	return newpromise
}
