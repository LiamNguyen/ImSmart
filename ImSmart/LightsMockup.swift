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
    static func lights(requireCellShake: Variable<Bool>, requireSynchronization: Variable<Bool>) -> [LightCellViewModel] {
        
        let kitchenrequireCellShake             = LightCellViewModel(
            light: Light(brightness: 0, area: "Kitchen"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let livingroomrequireCellShake          = LightCellViewModel(
            light: Light(brightness: 0, area: "Livingroom"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
                
        let frontYardrequireCellShake           = LightCellViewModel(
            light: Light(brightness: 70, area: "Front yard"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let backYardrequireCellShake            = LightCellViewModel(
            light: Light(brightness: 50, area: "Back yard"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let myBedroomrequireCellShake           = LightCellViewModel(
            light: Light(brightness: 0, area: "My bedroom"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let hersheyBedroomrequireCellShake      = LightCellViewModel(
            light: Light(brightness: 0, area: "Hershey bedroom"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let tobleronBedroomrequireCellShake     = LightCellViewModel(
            light: Light(brightness: 0, area: "Tobleron bedroom"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let firstFloorToiletrequireCellShake    = LightCellViewModel(
            light: Light(brightness: 0, area: "1st floor toilet"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        let secondFloorToiletrequireCellShake   = LightCellViewModel(
            light: Light(brightness: 0, area: "2nd floor toilet"),
            requireCellShake: requireCellShake,
            requireSynchronization: requireSynchronization
        )
        
        return [
            kitchenrequireCellShake,
            livingroomrequireCellShake,
            frontYardrequireCellShake,
            backYardrequireCellShake,
            myBedroomrequireCellShake,
            hersheyBedroomrequireCellShake,
            tobleronBedroomrequireCellShake,
            firstFloorToiletrequireCellShake,
            secondFloorToiletrequireCellShake
        ]
    }
}
