//
//  LightModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class LightModel {
    var id          : Int!
    var isOn        : Bool!
    var brightness  : Int!
    var area        : String!
    
    init(id: Int, isOn: Bool, brightness: Int, area: String) {
        self.id         = id
        self.isOn       = isOn
        self.brightness = brightness
        self.area       = area
    }
}
