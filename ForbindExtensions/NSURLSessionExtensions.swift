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

open class TaskPromise<T> : Promise<T> {
	open var task : URLSessionTask?
	
	public override init(value : T? = nil) {
		super.init(value: value)
	}
	
	deinit {
		if value == nil {
			task?.cancel()
		}
	}
}

extension URLSession {
	public func reset() -> Promise<Void> {
		let promise = Promise<Void>()
		self.reset { promise.setValue(Void()) }
		return promise
	}
	
	public func flush() -> Promise<Void> {
		let promise = Promise<Void>()
		self.flush { promise.setValue(Void()) }
		return promise
	}
	
	public func getTasks() -> Promise<([URLSessionDataTask], [URLSessionUploadTask], [URLSessionDownloadTask])> {
		let promise = Promise<([URLSessionDataTask], [URLSessionUploadTask], [URLSessionDownloadTask])>()
		getTasksWithCompletionHandler {
			promise.setValue($0 as [URLSessionDataTask], $1 as [URLSessionUploadTask], $2 as [URLSessionDownloadTask])
		}
		return promise
	}
	
	public func dataTask(_ request : URLRequest) -> TaskPromise<Result<(Data, URLResponse)>> {
		let promise = TaskPromise<Result<(Data, URLResponse)>>()
		
		promise.task = self.dataTask(with: request) { data, response, error in
			if let error = error {
				promise.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
	
	public func dataTask(_ url : URL) -> TaskPromise<Result<(Data, URLResponse)>> {
		let promise = TaskPromise<Result<(Data, URLResponse)>>()
		
		promise.task = self.dataTask(with: url) { [weak promise] data, response, error in
			if let error = error {
				promise?.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise?.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
	
	public func uploadTask(_ request : URLRequest, fromFile fileURL : URL) -> TaskPromise<Result<(Data, URLResponse)>> {
		let promise = TaskPromise<Result<(Data, URLResponse)>>()
		
		promise.task = self.uploadTask(with: request, fromFile: fileURL) { data, response, error in
			if let error = error {
				promise.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
	
	public func uploadTask(_ request : URLRequest, fromData bodyData: Data?) -> TaskPromise<Result<(Data, URLResponse)>> {
		let promise = TaskPromise<Result<(Data, URLResponse)>>()
		
		promise.task = self.uploadTask(with: request, from: bodyData) { data, response, error in
			if let error = error {
				promise.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
	
	public func downloadTask(_ request : URLRequest) -> TaskPromise<Result<(URL, URLResponse)>> {
		let promise = TaskPromise<Result<(URL, URLResponse)>>()
		
		promise.task = self.downloadTask(with: request) { data, response, error in
			if let error = error {
				promise.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
	
	public func downloadTask(_ URL : Foundation.URL) -> TaskPromise<Result<(Foundation.URL, URLResponse)>> {
		let promise = TaskPromise<Result<(Foundation.URL, URLResponse)>>()
		
		promise.task = self.downloadTask(with: URL) { data, response, error in
			if let error = error {
				promise.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
	
	public func downloadTask(_ resumeData : Data) -> TaskPromise<Result<(URL, URLResponse)>> {
		let promise = TaskPromise<Result<(URL, URLResponse)>>()
		
		promise.task = self.downloadTask(withResumeData: resumeData) { data, response, error in
			if let error = error {
				promise.setValue(.error(error))
			} else {
				let value = (data!, response!)
				promise.setValue(.ok(value))
			}
		}
		
		promise.task?.resume()
		
		return promise
	}
}
