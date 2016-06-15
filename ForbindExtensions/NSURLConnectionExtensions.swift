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
	public class func sendRequest(_ queue: OperationQueue) -> (URLRequest) -> Promise<Result<(URLResponse, Data)>> {
		return { sendRequest($0, queue: queue) }
	}
	
	public class func sendURLRequest(_ queue: OperationQueue) -> (URL) -> Promise<Result<(URLResponse, Data)>> {
		return { sendRequest(URLRequest(url: $0), queue: queue) }
	}
	
	public class func sendRequest(_ request: URLRequest, queue: OperationQueue) -> Promise<Result<(URLResponse, Data)>> {
		let promise = Promise<Result<(URLResponse, Data)>>()
		
		sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error in
			DispatchQueue.main.async {
				if let error = error {
					promise.setValue(.error(error))
				} else {
					promise.setValue(.ok(response!, data!))
				}
			}
		})
		
		return promise
	}
}
