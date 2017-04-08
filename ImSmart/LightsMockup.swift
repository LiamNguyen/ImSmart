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
    static func lights(lightViewModel: LightViewModel) -> [LightCellViewModel] {
        
        let kitchenLightViewModel           = LightCellViewModel(
            light: Light(brightness: 0, area: "Kitchen"),
            parentViewModel: lightViewModel
        )
        
        let livingroomLightViewModel        = LightCellViewModel(
            light: Light(brightness: 0, area: "Livingroom"),
            parentViewModel: lightViewModel
        )
                
        let frontYardLightViewModel         = LightCellViewModel(
            light: Light(brightness: 70, area: "Front yard"),
            parentViewModel: lightViewModel
        )
        
        let backYardLightViewModel          = LightCellViewModel(
            light: Light(brightness: 50, area: "Back yard"),
            parentViewModel: lightViewModel
        )
        
        let myBedroomLightViewModel         = LightCellViewModel(
            light: Light(brightness: 0, area: "My bedroom"),
            parentViewModel: lightViewModel
        )
        
        let hersheyBedroomLightViewModel    = LightCellViewModel(
            light: Light(brightness: 0, area: "Hershey bedroom"),
            parentViewModel: lightViewModel
        )
        
        let tobleronBedroomLightViewModel   = LightCellViewModel(
            light: Light(brightness: 0, area: "Tobleron bedroom"),
            parentViewModel: lightViewModel
        )
        
        let firstFloorToiletLightViewModel  = LightCellViewModel(
            light: Light(brightness: 0, area: "1st floor toilet"),
            parentViewModel: lightViewModel
        )
        
        let secondFloorToiletLightViewModel  = LightCellViewModel(
            light: Light(brightness: 0, area: "2nd floor toilet"),
            parentViewModel: lightViewModel
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
