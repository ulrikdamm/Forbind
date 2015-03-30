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
	class func toData(obj : AnyObject, options : NSJSONWritingOptions = nil) -> Result<NSData> {
		var error : NSError?
		let result = dataWithJSONObject(obj, options: options, error: &error)
		
		if let error = error {
			return .Error(error)
		} else {
			return .Ok(Box(result!))
		}
	}
	
	class func toJSON(data : NSData, options : NSJSONReadingOptions = nil) -> Result<AnyObject> {
		var error : NSError?
		let result : AnyObject? = JSONObjectWithData(data, options: options, error: &error)
		
		if let error = error {
			return .Error(error)
		} else {
			return .Ok(Box(result!))
		}
	}
}
