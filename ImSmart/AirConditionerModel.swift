//
//  AirConditionerModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

class AirConditionerModel {
    var id          : Int!
    var isOn        : Bool!
    var fanSpeed    : String!
    var swing       : String!
    var mode        : String!
    var temperature : Double!
    var isTimerOn   : Bool!
    var offTime     : NSDate!
    var area        : String!
    
    init(
        id          : Int,
        isOn        : Bool,
        fanSpeed    : String,
        swing       : String,
        mode        : String,
        temperature : Double,
        isTimerOn   : Bool,
        offTime     : NSDate,
        area        : String) {
        self.id             = id
        self.isOn           = isOn
        self.fanSpeed       = fanSpeed
        self.swing          = swing
        self.mode           = mode
        self.temperature    = temperature
        self.isTimerOn      = isTimerOn
        self.offTime        = offTime
        self.area           = area
    }
}
