# Forbind

Functional chaining and promises in Swift

Note: still in an experimental state. Everything could change. I would love some feedback on this. Write to [@ulrikdamm](https://twitter.com/ulrikdamm) on Twitter.

# What is it

Bind local or async expressions together functionally, all error handling taken care of for you:

```swift
func getUser(id : String) -> Promise<Result<User>> {
	let data = NSURL(string: id)
		=> { NSURLRequest(URL: $0) }
		=> NSURLConnection.sendRequest(.mainQueue())
		=> { response, data in data }
	
	return data
		=> NSJSONSerialization.toJSON(options: nil)
		=> { $0.dictionaryValue }
		=> User.fromJSON
}
```

• Bind operations together with =>

• No error handling inside your logic

• Transparent async calls

• No if-lets

• Combine inputs with ++

For more details, read my [Blog post](http://ufd.dk/blog/Binds-and-promises-with-Forbind).

# Get started

You can add Forbind to your project using [Cocoapods](https://cocoapods.org). Just add it to your Podfile:

```ruby
use_frameworks!

pod 'Forbind', '~> 1.1'
pod 'ForbindExtensions', :git => 'https://github.com/ulrikdamm/Forbind'
```

(You need the ```use_frameworks!``` since that feature of Cocoapods is still in beta. ForbindExtensions are optional)

Or you can add it using [Carthage](https://github.com/Carthage/Carthage) by adding this to your cartfile:

```
github "ulrikdamm/Forbind" ~> 1.0
```

This will add both Forbind.framework and ForbindExtensions.framework, which you can drag into your Xcode project.

Then in your files just import Forbind and optionally ForbindExtensions

```
import Forbind
import ForbindExtensions
```

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
