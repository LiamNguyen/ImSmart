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
    
    func getAllLights(completionHandler: @escaping (_ allLights: NSArray, _ error: String) -> Void) -> Void
    func updateAllLights(lights: String, completionHandler: @escaping (_ success: Bool) -> Void) -> Void
    
//    **MARK: AIR CONDITIONERS
    
    func getAllAirConditioners(completionHandler: @escaping (_ allAirConditioner: NSArray, _ error: String) -> Void) -> Void
    func updateAllAirConditioners(allAirConditioners: String, completionHandler: @escaping (_ success: Bool) -> Void) -> Void
}
