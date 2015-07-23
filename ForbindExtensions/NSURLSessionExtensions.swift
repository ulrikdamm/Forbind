//
//  NSURLSessionExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 27/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import Forbind

// Some methods return a Void promise. This is the same as an async method
// returning Void. Chain it together with something else to make it run serially,
// but without any closures needed.

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
			promise.setValue($0 as [NSURLSessionDataTask], $1 as [NSURLSessionUploadTask], $2 as [NSURLSessionDownloadTask])
		}
		return promise
	}
	
	public func dataTask(request : NSURLRequest) -> (NSURLSessionTask, Promise<Result<(NSData, NSURLResponse)>>) {
		let promise = Promise<Result<(NSData, NSURLResponse)>>()
		
		let task = dataTaskWithRequest(request) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public func dataTask(url : NSURL) -> (NSURLSessionDataTask, Promise<Result<(NSData, NSURLResponse)>>) {
		let promise = Promise<Result<(NSData, NSURLResponse)>>()
		
		let task = dataTaskWithURL(url) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public func uploadTask(request : NSURLRequest, fromFile fileURL : NSURL) -> (NSURLSessionUploadTask, Promise<Result<(NSData, NSURLResponse)>>) {
		let promise = Promise<Result<(NSData, NSURLResponse)>>()
		
		let task = uploadTaskWithRequest(request, fromFile: fileURL) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public func uploadTask(request : NSURLRequest, fromData bodyData: NSData?) -> (NSURLSessionUploadTask, Promise<Result<(NSData, NSURLResponse)>>) {
		let promise = Promise<Result<(NSData, NSURLResponse)>>()
		
		let task = uploadTaskWithRequest(request, fromData: bodyData) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public func downloadTask(request : NSURLRequest) -> (NSURLSessionDownloadTask, Promise<Result<(NSURL, NSURLResponse)>>) {
		let promise = Promise<Result<(NSURL, NSURLResponse)>>()
		
		let task = downloadTaskWithRequest(request) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public func downloadTask(URL : NSURL) -> (NSURLSessionDownloadTask, Promise<Result<(NSURL, NSURLResponse)>>) {
		let promise = Promise<Result<(NSURL, NSURLResponse)>>()
		
		let task = downloadTaskWithURL(URL) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public func downloadTask(resumeData : NSData) -> (NSURLSessionDownloadTask, Promise<Result<(NSURL, NSURLResponse)>>) {
		let promise = Promise<Result<(NSURL, NSURLResponse)>>()
		
		let task = downloadTaskWithResumeData(resumeData) { data, response, error in
			if let error = error {
				promise.setValue(.Error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.Ok(value))
			}
		}
		
		return (task, promise)
	}
	
	public class func startTaskAndGetResult<T>(task : NSURLSessionTask, result : Promise<Result<(T, NSURLResponse)>>) -> Promise<Result<(T, NSURLResponse)>> {
		task.resume()
		return result
	}
}
