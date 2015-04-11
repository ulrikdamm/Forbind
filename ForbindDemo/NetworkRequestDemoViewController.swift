//
//  NetworkRequestDemoViewController.swift
//  Forbind
//
//  Created by Ulrik Damm on 29/03/15.
//
//

import UIKit
import Forbind
import ForbindExtensions

// This example shows using NSURLConnection to load a source, and then parsing
// the result to a string.
// Notice that the input might be nil, NSURL(string: $0) might return nil, 
// the network request might fail, and the data to string parsing might fail.
// All these errors are handled, and without using a single if-let, or any
// inline error handling. Try removing the IB connection to the input field, or
// loading a URL that doesn't exist, and see it fail gracefully.

class NetworkRequestDemoViewController : UIViewController {
	@IBOutlet var textView : UITextView?
	@IBOutlet var input : UITextField?
	@IBOutlet var spinner : UIActivityIndicatorView?
	
	@IBAction func loadSource(sender : AnyObject?) {
		spinner?.startAnimating()
		input?.resignFirstResponder()
		
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		
		let request = input?.text
			=> { NSURL(string: $0) }
			=> { NSURLRequest(URL: $0) }
		
		let result = request
			=> session.dataTask
			=> NSURLSession.startTaskAndGetResult
			=> { data, response in NSString(data: data, encoding: NSUTF8StringEncoding) as? String }
		
		result.getValue { [weak self] value in
			self?.spinner?.stopAnimating()
			
			switch value {
			case .Ok(let box): self?.handleSuccess(box.value)
			case .Error(let error): self?.handleFailure(error)
			}
		}
	}
	
	func handleSuccess(text : String) {
		self.textView?.textColor = .blackColor()
		self.textView?.text = text
	}
	
	func handleFailure(error : NSError) {
		self.textView?.textColor = .redColor()
		self.textView?.text = error.localizedDescription
	}
}
