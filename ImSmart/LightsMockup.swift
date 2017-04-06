//
//  LightsMockup.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /05/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxSwift

struct LightsMockup {
    static func lights() -> [LightViewModel] {
        
        let kitchenLightViewModel           = LightViewModel(
            light: Light(brightness: 0, area: "Kitchen")
        )
        
        let livingroomLightViewModel        = LightViewModel(
            light: Light(brightness: 0, area: "Livingroom")
        )
                
        let frontYardLightViewModel         = LightViewModel(
            light: Light(brightness: 70, area: "Front yard")
        )
        
        let backYardLightViewModel          = LightViewModel(
            light: Light(brightness: 50, area: "Back yard")
        )
        
        let myBedroomLightViewModel         = LightViewModel(
            light: Light(brightness: 0, area: "My bedroom")
        )
        
        let hersheyBedroomLightViewModel    = LightViewModel(
            light: Light(brightness: 0, area: "Hershey bedroom")
        )
        
        let tobleronBedroomLightViewModel   = LightViewModel(
            light: Light(brightness: 0, area: "Tobleron bedroom")
        )
        
        let firstFloorToiletLightViewModel  = LightViewModel(
            light: Light(brightness: 0, area: "1st floor toilet")
        )
        
        let secondFloorToiletLightViewModel  = LightViewModel(
            light: Light(brightness: 0, area: "2nd floor toilet")
        )
        
        return [
            kitchenLightViewModel,
            livingroomLightViewModel,
            frontYardLightViewModel,
            backYardLightViewModel,
            myBedroomLightViewModel,
            hersheyBedroomLightViewModel,
            tobleronBedroomLightViewModel,
            firstFloorToiletLightViewModel,
            secondFloorToiletLightViewModel
        ]
    }
}
