//
//  NSJSONSerializationExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 30/03/15.
//
//

import Foundation
import Forbind

public enum JSONResult {
	case Array(NSArray)
	case Dictionary(NSDictionary)
	
	public var arrayValue : NSArray? {
		switch self {
		case .Array(let a): return a
		case _: return nil
		}
	}
	
	public var dictionaryValue : NSDictionary? {
		switch self {
		case .Dictionary(let d): return d
		case _: return nil
		}
	}
}

extension NSJSONSerialization {
	public class func toData(options : NSJSONWritingOptions) -> AnyObject throws -> NSData {
		return { try dataWithJSONObject($0, options: options) }
	}
	
	public class func toJSON(options : NSJSONReadingOptions = []) -> NSData throws -> JSONResult {
		return { data in
			let result = try JSONObjectWithData(data, options: options)
			
			if let result = result as? NSArray {
				return .Array(result)
			} else if let result = result as? NSDictionary {
				return .Dictionary(result)
			} else {
				fatalError("Invalid return value from JSONObjectWithData: \(result)")
			}
		}
	}
}
