# Forbind

Functional chaining and promises in Swift

Note: still in an experimental state. Everything could change. I would love some feedback on this. Write to [@ulrikdamm](https://twitter.com/ulrikdamm) on Twitter.

# What is it

Forbind is a library to introduce functional chaining of expressions into your Swift code. It contains a lot of powerful components for writing code that is stateless and expressive. It’s key features are:

• A bind operator (=>) to bind expressions together, that can handle errors.

• A combine operator (++) to combine two potentially optional values together.

• A Result type for better error handling.

• A Promise type for better handling of async values.

• Some extensions for Foundation and UIKit which introduces Forbind concepts in common classes.

When you put these features together, you can begin to write your code in a whole new way. No if-lets, no code littered with error handling, no many-times indented code.

The idea is that you can write your code as a series of expressions, which produce a final result. All error handling is left until the end, when you unpack the result. And it works even for async operations. No more if-lets, no more NSErrorPointer checking, no more completion blocks. Your code changes from something like this:

```swift
if let data = readFile("file") {
	if let result = parseJson(data, error: nil) as? NSDictionary {
		if let thingy = parseData(result) {
			handleResult(thingy)
		}
	}
}
```

To something like this:

```swift
readFile("file") => parseJson => parseData => handleResult
```

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

For more examples, open the Xcode project and run the ForbindDemo iOS app. It has a few practical examples. Or you can just see the sources files for the [animation demo](https://github.com/ulrikdamm/Forbind/blob/master/ForbindDemo/ChainedAnimationsDemoViewController.swift), the [network request demo](https://github.com/ulrikdamm/Forbind/blob/master/ForbindDemo/NetworkRequestDemoViewController.swift) and the [print IP demo](https://github.com/ulrikdamm/Forbind/blob/master/ForbindDemo/PrintIPDemoViewController.swift)

The whole library is in the files [bind.swift](https://github.com/ulrikdamm/Forbind/blob/master/Forbind/Bind.swift), [combine.swift](https://github.com/ulrikdamm/Forbind/blob/master/Forbind/Combine.swift) and [dataStructures.swift](https://github.com/ulrikdamm/Forbind/blob/master/Forbind/DataStructures.swift). Each file has comments explaining how it works in more detail.

If you want to learn more about the concept behind the bind operator, you can read my [blog post](http://ulrikdamm.logdown.com/posts/247219) about it.

# Get started

You can add Forbind to your project using [Cocoapods](https://cocoapods.org). Just add it to your Podfile:

```ruby
use_frameworks!

pod 'Forbind', :git => 'git@github.com:ulrikdamm/Forbind.git'
```

(You need the ```use_frameworks!``` since that feature of Cocoapods is still in beta. This currently only includes Forbind, not ForbindExtensions)

Or you can add it using [Carthage](https://github.com/Carthage/Carthage) by adding this to your cartfile:

```
github "ulrikdamm/Forbind" ~> 1.0
```

This will add both Forbind.framework and ForbindExtensions.framework, which you can drag into your Xcode project.

The Forbind library is the bind operator (```=>```) and the combine operator (```++```), along with the Result enum and Promise classes.

ForbindExtensions are extensions to Foundation and UIKit for working better with Forbind, by, for example, returning a promise instead of using a completion block. The ForbindExtensions are still a work in progress, so you might want to make your own extensions instead. In this case, just only include the Forbind framework.

# What is the state of the project?

It’s still very experimental, so I would love some feedback on it. I wouldn’t recommend relying on this for product code yet. If you have a good idea, or just questions, submit a pull request or contact me at [@ulrikdamm](https://twitter.com/ulrikdamm) on Twitter.

Things that still needs to be considered:

• General direction of the project (are there some fundamental flaws?)

• Promise cancellation (support for cancelling an async operation if a promise is deallocated)

• Handling of dispatch queues (currently promise callbacks are run on the same queue as the operation finished on)

• More extensions for common UIKit/AppKit/Foundation methods to use Promise and Result instead of NSErrorPointer and completion blocks.

• "Expression was too complex to be solved in reasonable time" for big expressions.
