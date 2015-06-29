//
//  NSURLSessionExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 27/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import Forbind

// NSURLSession calls are a bit tricky, since they return both a task and a completion handler
// With Forbind, they return a task and a result promise, and you can unpack it like this:
//
// let request = NSURLRequest(URL: url) => NSURLSession().dataTask
// request => { task, _ in task } => handleTask
// request => { $1 } => handleResponse
//
// Alternatively, use the convenience method startTaskAndGetResult like this:
//
// let result = NSURLRequest(URL: url)
//     => NSURLSession().dataTask
//     => NSURLSession.startTaskAndGetResult
//     => handleResponse

// Some methods return a Void promise. This is the same as an async method
// returning Void. Chain it together with something else to make it run serially,
// but without any closures needed.

public class TaskPromise<T> : Promise<T> {
	public var task : NSURLSessionTask?
	
	public override init(value : T? = nil) {
		super.init(value: value)
	}
	
	deinit {
		if value == nil {
			task?.cancel()
		}
	}
}

extension NSURLSession {
	public func reset() -> Promise<Void> {
		let promise = Promise<Void>()
		resetWithCompletionHandler { promise.setValue(Void()) }
		return promise
	}
	
	public func flush() -> Promise<Void> {
		let promise = Promise<Void>()
		flushWithCompletionHandler { promise.setValue(Void()) }
		return promise
	}
	
	public func getTasks() -> Promise<([NSURLSessionDataTask], [NSURLSessionUploadTask], [NSURLSessionDownloadTask])> {
		let promise = Promise<([NSURLSessionDataTask], [NSURLSessionUploadTask], [NSURLSessionDownloadTask])>()
		getTasksWithCompletionHandler {
			promise.setValue($0 as! [NSURLSessionDataTask], $1 as! [NSURLSessionUploadTask], $2 as! [NSURLSessionDownloadTask])
		}
		return promise
	}
	
	public func dataTask(request : NSURLRequest) -> Promise<Result<(NSData, NSURLResponse)>> {
		let promise = Promise<Result<(NSData, NSURLResponse)>>()
		
		let task = dataTaskWithRequest(request) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
	
	public func dataTask(url : NSURL) -> TaskPromise<Result<(NSData, NSURLResponse)>> {
		let promise = TaskPromise<Result<(NSData, NSURLResponse)>>()
		
		promise.task = dataTaskWithURL(url) { [weak promise] data, response, error in
			if let error = error {
				promise?.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise?.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
	
	public func uploadTask(request : NSURLRequest, fromFile fileURL : NSURL) -> TaskPromise<Result<(NSData, NSURLResponse)>> {
		let promise = TaskPromise<Result<(NSData, NSURLResponse)>>()
		
		promise.task = uploadTaskWithRequest(request, fromFile: fileURL) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
	
	public func uploadTask(request : NSURLRequest, fromData bodyData: NSData?) -> TaskPromise<Result<(NSData, NSURLResponse)>> {
		let promise = TaskPromise<Result<(NSData, NSURLResponse)>>()
		
		promise.task = uploadTaskWithRequest(request, fromData: bodyData) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
	
	public func downloadTask(request : NSURLRequest) -> TaskPromise<Result<(NSURL, NSURLResponse)>> {
		let promise = TaskPromise<Result<(NSURL, NSURLResponse)>>()
		
		promise.task = downloadTaskWithRequest(request) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
	
	public func downloadTask(URL : NSURL) -> TaskPromise<Result<(NSURL, NSURLResponse)>> {
		let promise = TaskPromise<Result<(NSURL, NSURLResponse)>>()
		
		promise.task = downloadTaskWithURL(URL) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
	
	public func downloadTask(resumeData : NSData) -> TaskPromise<Result<(NSURL, NSURLResponse)>> {
		let promise = TaskPromise<Result<(NSURL, NSURLResponse)>>()
		
		promise.task = downloadTaskWithResumeData(resumeData) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(Box(value)))
			}
		}
		
		return promise
	}
}
