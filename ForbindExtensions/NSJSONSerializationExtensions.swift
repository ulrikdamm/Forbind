//
//  NSJSONSerializationExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 30/03/15.
//
//

import Foundation
import Forbind

extension NSJSONSerialization {
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
	
	public class func toData(options : NSJSONWritingOptions)(obj : AnyObject) -> Result<NSData> {
		do {
			return .Ok(try dataWithJSONObject(obj, options: options))
		} catch let error {
			return .Error(error as NSError)
		}
	}
	
	public class func toJSON(options : NSJSONReadingOptions = [])(data : NSData) -> Result<JSONResult> {
		do {
			let result = try JSONObjectWithData(data, options: options)
			
			if let result = result as? NSArray {
				return .Ok(.Array(result))
			} else if let result = result as? NSDictionary {
				return .Ok(.Dictionary(result))
			} else {
				fatalError("Invalid return value from JSONObjectWithData: \(result)")
			}
		} catch let error {
			return .Error(error as NSError)
		}
	}
}