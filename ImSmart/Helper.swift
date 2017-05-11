//
//  Helper.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /09/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class Helper {
//** Mark: CONVERT JSON OBJ TO STRING

    static func jsonStringify(_ jsonObject: AnyObject) -> String {
        let jsonValidObject = JSONSerialization.isValidJSONObject(jsonObject)
        if !jsonValidObject {
            print("Invalid JSON object")
            return String()
        }
        
        let data        = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
        if let nsString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            return nsString as String
        }
        
        NSLog("%@", "NSString conversion failed")
        return String()
    }
    
    static func removeDecimalPartFromString(afterConvertedFromDouble string: String) -> String {
        let pattern = ".[0-9]*$"
        do {
            let regex   = try NSRegularExpression(pattern: pattern, options: [])
            return regex.stringByReplacingMatches(
                in: string,
                options: [],
                range: NSRange(location: 0, length: string.characters.count),
                withTemplate: ""
            )
        } catch let error {
            print(error)
            return ""
        }
    }
}
