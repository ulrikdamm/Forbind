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
	case array(NSArray)
	case dictionary(NSDictionary)
	
	public var arrayValue : NSArray? {
		switch self {
		case .array(let a): return a
		case _: return nil
		}
	}
	
	public var dictionaryValue : NSDictionary? {
		switch self {
		case .dictionary(let d): return d
		case _: return nil
		}
	}
}

extension JSONSerialization {
	public class func toData(_ options : JSONSerialization.WritingOptions) -> (AnyObject) throws -> Data {
		return { try data(withJSONObject: $0, options: options) }
	}
	
	public class func toJSON(_ options : JSONSerialization.ReadingOptions = []) -> (Data) throws -> JSONResult {
		return { data in
			let result = try jsonObject(with: data, options: options)
			
			if let result = result as? NSArray {
				return .array(result)
			} else if let result = result as? NSDictionary {
				return .dictionary(result)
			} else {
				fatalError("Invalid return value from JSONObjectWithData: \(result)")
			}
		}
	}
}
