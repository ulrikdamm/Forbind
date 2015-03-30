//
//  PrintIPDemoViewController.swift
//  Forbind
//
//  Created by Ulrik Damm on 30/03/15.
//
//

import Foundation
import UIKit
import Forbind
import ForbindExtensions

class PrintIPDemoViewController : UIViewController {
	@IBOutlet var label : UILabel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		printIP()
	}
	
	func sendRequest(request : NSURLRequest) -> ResultPromise<NSData> {
		return (request ++ NSOperationQueue.mainQueue()) => NSURLConnection.sendAsynchronousRequest => { response, data in data! }
	}
	
	func parseJson(data : NSData) -> Result<String> {
		return data
			=> NSJSONSerialization.toJSON(options: nil)
			=> { data in data as? [NSObject: AnyObject] }
			=> { data in data["ip"] as? String }
	}
	
	func printIP() {
		let myIP = "http://ip.jsontest.com"
			=> { NSURL(string: $0) }
			=> { NSURLRequest(URL: $0) }
			=> sendRequest
			=> parseJson
		
		myIP.getValue { value in
			switch value {
			case .Ok(let box):
				self.label?.text = "Your ip: \(box.value)"
			case .Error(let error):
				self.label?.text = "Something went wrong: \(error.localizedDescription)"
			}
		}
	}
}
