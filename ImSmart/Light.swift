//
//  Light.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /04/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class Light: NSCoder {
    var isOn        : Bool!
    var brightness  : Int!
    var area        : String!
    
    init(brightness: Int, area: String) {
        self.isOn       = false
        self.brightness = brightness
        self.area       = area
    }
    
    required init(coder aDecoder: NSCoder) {
        self.isOn       = aDecoder.decodeObject(forKey: EncoderKey.isOn.rawValue)       as? Bool    ?? false
        self.brightness = aDecoder.decodeObject(forKey: EncoderKey.brightness.rawValue) as? Int     ?? 0
        self.area       = aDecoder.decodeObject(forKey: EncoderKey.area.rawValue)       as? String  ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.isOn, forKey: EncoderKey.isOn.rawValue)
        aCoder.encode(self.brightness, forKey: EncoderKey.brightness.rawValue)
        aCoder.encode(self.area, forKey: EncoderKey.area.rawValue)
    }
    
    private enum EncoderKey: String {
        case isOn       = "isOn"
        case brightness = "brightness"
        case area       = "area"
    }
}
