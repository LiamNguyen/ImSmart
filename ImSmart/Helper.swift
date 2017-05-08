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
    
    static func printMockupLights(_ mockupLights: [LightCellViewModel]) {
        let _ = mockupLights
            .map({ lightCellViewModel in
                print("__________Start item")
                print("Area: \(lightCellViewModel.area.value)")
                print("Brigtness: \(lightCellViewModel.brightness.value)")
                print("Light is on \(lightCellViewModel.isOn.value)")
                print("__________End item")
            })
        print("\n_____________DONE RECEVING_____________\n")
    }
}
