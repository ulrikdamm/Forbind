//: Playground - noun: a place where people can play

import UIKit
import Forbind

let a = Promise<String>(value: "I am")
let b = Promise<String>(value: "not")
let c = Promise<String>(value: "Ulrik")

let inp = [a, b, c]
let f = inp => { map($0) { "\($0)!" } }
let g = f => { filter($0) { $0 != "not!" } }
let gg = g => { map($0) { "\($0) " } }
let ggg = gg => { reduce($0, "", +) }

ggg.getValue { v in
	println(v)
}
