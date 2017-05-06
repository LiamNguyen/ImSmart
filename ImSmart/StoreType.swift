//
//  StoreType.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /02/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

protocol StoreType {
//    **MARK: LIGHTS
    
    func getAllLights(_ completionHandler: @escaping (_ allLights: [LightModel], _ error: String?) -> Void) -> Void
    func updateAllLights(_ lights: String, completionHandler: @escaping (_ success: Bool) -> Void) -> Void
    
//    **MARK: AIR CONDITIONERS
    
    func getAllAirConditioners(_ completionHandler: @escaping (_ allAirConditioner: [AirConditionerModel], _ error: String?) -> Void) -> Void
    func updateAllAirConditioners(_ allAirConditioners: String, completionHandler: @escaping (_ success: Bool) -> Void) -> Void
}
