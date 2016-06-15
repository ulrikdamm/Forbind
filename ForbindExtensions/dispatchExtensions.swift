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

public func dispatchAfter<T>(_ promise : Promise<T>, when : DispatchTime, queue : DispatchQueue) -> Promise<T> {
	let newpromise = Promise<T>(previousPromise: promise)
	
	promise.getValue { value in
		queue.after(when: when) {
			newpromise.setValue(value)
		}
	}
	
	return newpromise
}

public func dispatchAsync<T>(_ promise : Promise<T>, queue : DispatchQueue) -> Promise<T> {
	let newpromise = Promise<T>(previousPromise: promise)
	
	promise.getValue { value in
		queue.async {
			newpromise.setValue(value)
		}
	}
	
	return newpromise
}
