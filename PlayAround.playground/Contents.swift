//: Playground - noun: a place where people can play

import UIKit
import Forbind

// Play around with Forbind here

let promiseStr = Promise<String>()

promiseStr.getValue(println)

promiseStr.setValue("Hello from the future!")

extension NSURLConnection {
	public class func sendRequest(queue : NSOperationQueue)(url : NSURL) -> Promise<Result<(NSURLResponse, NSData)>> {
		return Promise<Result<(NSURLResponse, NSData)>>(value: .Error(NSError(domain: "", code: 0, userInfo: nil)))
	}
}

extension NSJSONSerialization {
	public class func toJSON(options : NSJSONReadingOptions = nil)(data : NSData) -> Result<AnyObject> {
		return .Error(NSError(domain: "", code: 0, userInfo: nil))
	}
}

struct User {
	let name : String
	
	static func parse(data : NSData) -> User {
		return User(name: "\(data)")
	}
}

let urls : [NSURL] = []

func loadUsers(ids : [String]) -> [Promise<Result<User>>] {
	return urls
		=> { id in NSURL(string: "http://startup.io/users/\(id)") }
		=> NSURLConnection.sendRequest(.mainQueue())
		=> { response, data in data }
		=> User.parse
}

for user in loadUsers(["ulrikdamm", "simonbs", "ksmandersen"]) {
	user.getValue { user in
		println("Loaded user: \(user)")
	}
}
