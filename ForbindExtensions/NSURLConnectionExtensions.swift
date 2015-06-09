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
	public class func sendRequest(queue: NSOperationQueue)(request: NSURLRequest) -> Promise<Result<(NSURLResponse, NSData)>> {
		return sendRequest(request, queue: queue)
	}
	
	public class func sendURLRequest(queue: NSOperationQueue)(url: NSURL) -> Promise<Result<(NSURLResponse, NSData)>> {
		return sendRequest(NSURLRequest(URL: url), queue: queue)
	}
	
	public class func sendRequest(request: NSURLRequest, queue: NSOperationQueue) -> Promise<Result<(NSURLResponse, NSData)>> {
		let promise = Promise<Result<(NSURLResponse, NSData)>>()
		
		sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error in
			dispatch_async(dispatch_get_main_queue()) {
				if let error = error {
					promise.setValue(.Error(error))
				} else {
					promise.setValue(.Ok(Box(response!, data!)))
				}
			}
		})
		
		return promise
	}
}
