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
	public class func toData(options : NSJSONWritingOptions = nil)(obj : AnyObject) -> Result<NSData> {
		var error : NSError?
		let result = dataWithJSONObject(obj, options: options, error: &error)
		
		if let error = error {
			return .Error(error)
		} else {
			return .Ok(Box(result!))
		}
	}
	
	public class func toJSON(options : NSJSONReadingOptions = nil)(data : NSData) -> Result<AnyObject> {
		var error : NSError?
		let result : AnyObject? = JSONObjectWithData(data, options: options, error: &error)
		
		if let error = error {
			return .Error(error)
		} else {
			return .Ok(Box(result!))
		}
	}
}
