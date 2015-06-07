//: Playground - noun: a place where people can play

import UIKit
import Forbind
import ForbindExtensions

// Play around with Forbind here

let promiseStr = Promise<String>()

promiseStr.getValue(println)

promiseStr.setValue("Hello from the future!")


struct User : Printable {
	let name : String
	
	static func parse(data : NSDictionary) -> User? {
		return (data["name"] as? String) => { User(name: $0) }
	}
	
	var description : String {
		return "User: \(name)"
	}
}

let urls : [NSURL] = []

func loadUsers(ids : [String]) -> [Promise<Result<User>>] {
	let data = ids
		=> { v in NSURL(string: "http://echo.jsontest.com/name/\(v)") }
		=> NSURLConnection.sendURLRequest(.mainQueue())
		=> { response, data in data }
	
	return data
		=> NSJSONSerialization.toJSON(options: nil)
		=> { $0.dictionaryValue }
		=> User.parse
}

let users = loadUsers(["ulrikdamm", "simonbs", "ksmandersen"])

for user in users {
	user.getValue { user in
		println("Loaded user: \(user)")
	}
}

let userCount = filterp(users) { $0.okValue != nil } => count

userCount.getValue { userCount in
	println("Loaded \(userCount) users")
}

NSRunLoop.mainRunLoop().runUntilDate(NSDate().dateByAddingTimeInterval(5))
