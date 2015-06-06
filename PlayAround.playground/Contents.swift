//: Playground - noun: a place where people can play

import UIKit
import Forbind

// Play around with Forbind here

let promiseStr = Promise<String>()

promiseStr.getValue(println)

promiseStr.setValue("Hello from the future!")
