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

    static func jsonStringify(jsonObject: AnyObject) -> String {
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
    
//** Mark: BUILD JSON OBJECT FROM ARRAY OF LIGHTS
    
    static func buildJSONObject(fromLightCellViewModel dataArray: [LightCellViewModel]) -> [[String: Any]] {
        return dataArray
                .map({ lightCellViewModel in
                    return [
                        "isOn"      : lightCellViewModel.isOn.value,
                        "brightness": lightCellViewModel.brightness.value,
                        "area"      : lightCellViewModel.area.value
                    ]
                })
    }
    
//** Mark: PARSE JSON TO MODEL AND RETURN ARRAY OF LIGHTS
    
    static func parseJSONToLightCellViewModel(data: Data, lightViewModel: LightViewModel) -> [LightCellViewModel] {
        do {
            let decoded = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let array = decoded as? NSArray {
                let receivedMockupLights = array.map({ item -> LightCellViewModel in
                    let dictionary = item as? NSDictionary
                    let light = Light(
                        brightness  : dictionary?["brightness"] as! Int,
                        area        : dictionary?["area"] as! String,
                        isOn        : dictionary?["isOn"] as! Bool
                    )
                    return LightCellViewModel(light: light, requireCellShake: lightViewModel.requireCellShake, requireSynchronization: lightViewModel.requireSynchronization)
                })
                return receivedMockupLights
            } else {
                NSLog("%@", "NSArray conversion failed")
            }
        } catch let error {
            NSLog("%@", "Failed to decode. Error: \(error)")
        }
        
        return [LightCellViewModel]()
    }
    
    static func printMockupLights(mockupLights: [LightCellViewModel]) {
        let _ = mockupLights
            .map({ lightCellViewModel in
                print("__________Start item")
                print("Area: \(lightCellViewModel.area.value)")
                print("Brigtness: \(lightCellViewModel.brightness.value)")
                print("Light is on \(lightCellViewModel.isOn.value)")
                print("__________End item")
            })
    }
}