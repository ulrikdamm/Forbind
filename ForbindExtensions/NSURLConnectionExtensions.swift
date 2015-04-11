//
//  NSURLConnectionExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 27/03/15.
//  Copyright (c) 2015 Ufd.dk. All rights reserved.
//

import Foundation
import Forbind

extension NSURLConnection {
	public class func sendRequest(queue: NSOperationQueue)(request: NSURLRequest) -> ResultPromise<(NSURLResponse, NSData)> {
		return sendRequest(request, queue: queue)
	}
	
	public class func sendRequest(request: NSURLRequest, queue: NSOperationQueue) -> ResultPromise<(NSURLResponse, NSData)> {
		let promise = ResultPromise<(NSURLResponse, NSData)>()
		
		sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error in
			dispatch_async(dispatch_get_main_queue()) {
				if let error = error {
					promise.setError(error)
				} else {
					let value = (response, data)
					promise.setOkValue(response!, data!)
				}
			}
		})
		
		return promise
	}
}
