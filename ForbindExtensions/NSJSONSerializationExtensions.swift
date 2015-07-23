//
//  NSJSONSerializationExtensions.swift
//  Forbind
//
//  Created by Ulrik Damm on 30/03/15.
//
//

import Foundation
import Forbind

//extension NSJSONSerialization {
//	public enum JSONResult {
//		case Array(NSArray)
//		case Dictionary(NSDictionary)
//		
//		public var arrayValue : NSArray? {
//			switch self {
//			case .Array(let a): return a
//			case _: return nil
//			}
//		}
//		
//		public var dictionaryValue : NSDictionary? {
//			switch self {
//			case .Dictionary(let d): return d
//			case _: return nil
//			}
//		}
//	}
//	
//	public class func toData(options : NSJSONWritingOptions)(obj : AnyObject) -> Result<NSData> {
//		do {
//			let result = try dataWithJSONObject(obj, options: options)
//			
//			
//		} catch let e {
//			return .Error(e)
//		}
//		
//		
//		if let error = error {
//			return .Error(error)
//		} else if let result = result {
//			return .Ok(Box(result))
//		} else {
//			fatalError("Nil return value from dataWithJSONObject")
//		}
//	}
//	
//	public class func toJSON(options : NSJSONReadingOptions = nil)(data : NSData) -> Result<JSONResult> {
//		var error : NSError?
//		let result : AnyObject? = JSONObjectWithData(data, options: options, error: &error)
//		
//		if let error = error {
//			return .Error(error)
//		} else if let result = result as? NSArray {
//			return .Ok(Box(.Array(result)))
//		} else if let result = result as? NSDictionary {
//			return .Ok(Box(.Dictionary(result)))
//		} else {
//			fatalError("Invalid return value from JSONObjectWithData: \(result)")
//		}
//	}
//}