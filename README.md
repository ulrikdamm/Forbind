# Forbind

Functional chaining in Swift

Note: still in an experimental state. Everything could change. I would love some feedback on this. Write to @ulrikdamm on Twitter.

# What is it

Forbind is a library to introduce functional chaining of expressions into your Swift code. It contains a lot of powerful components for writing code that is stateless and expressive. It’s key features are:

• A bind operator (=>) to bind expressions together, that can handle errors.

• A combine operator (++) to combine two potentially optional values together.

• A Result type for better error handling.

• A Promise type for better handling of async values.

• Some extensions for Foundation and UIKit which introduces Forbind concepts in common classes.

When you put these features together, you can begin to write your code in a whole new way. No if-lets, no code littered with error handling, no many-times indented code.

# Show me an example of it

Let’s try to do a simple network request with NSURLConnection. Here’s how it probably will look today:

```swift
class NetworkRequestExampleOldWay {
	func handleResponse(response : NSURLResponse?, data : NSData?) -> String? {
		if let data = data {
			return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
		} else {
			return nil
		}
	}
	
	func performRequest(completion : (String?, NSError?) -> Void) {
		if let url = NSURL(string: "http://ufd.dk") {
			let request = NSURLRequest(URL: url)
			NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
				if let error = error {
					completion(nil, error)
				} else {
					if let result = self.handleResponse(response, data: data) {
						completion(result, nil)
					} else {
						completion(nil, nil)
					}
				}
			}
		}
	}
}
```

There’s some problems with this:

• Need to have all your code nested in an if-let.

• Error and data can have a value at the same time.

• You might forget handling the error.

• Error handling and logic in between each other.

• Error handling at multiple different places.

• Multiple levels of indention.

• Completion call with two nils? Let’s hope that doesn’t cause problems.

• 25 lines.

Here’s how you would do the exact same with Forbind:

```swift
class NetworkRequestExampleWithForbind {
	func handleResponse(response : NSURLResponse?, data : NSData?) -> String? {
		return data => { NSString(data: $0, encoding: NSUTF8StringEncoding) as? String }
	}
	
	func performRequest() -> ResultPromise<String> {
		let request = NSURL(string: "http://ufd.dk") => { NSURLRequest(URL: $0) }
		let response = request ++ NSOperationQueue.mainQueue() => NSURLConnection.sendAsynchronousRequest
		return response => handleResponse
	}
}
```

Problems solved with this:

• You define all your logic before you do any error handling.

• You are forced to handle all errors.

• Only indentation is when receiving the final result.

• 9 lines!!

There are some conventions that are changed from the usual way of writing code:

• Nested calls becomes chained calls (```func1 => func2``` instead ```func2(func1())```)

• Chain calls with multiple arguments are ```++```’ed together (```arg1 ++ arg2 => func``` instead of ```func(arg1, arg2)```)

• You do error handling in the end. If anything fails, it skips the rest.

# I’m intrigued. How do I learn more?

The whole library is in the files bind.swift, combine.swift and dataStructures.swift. Each file has comments explaining how it works in more detail.

# What is the state of the project?

It’s still very experimental, so I would love some feedback on it. I wouldn’t recommend relying on this for product code yet. If you have a good idea, or just questions, submit a pull request or contact me at @ulrikdamm on Twitter.
