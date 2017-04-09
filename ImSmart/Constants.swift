//
//  Constants.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Window {
        static let screenWidth  = Float(UIScreen.main.bounds.width)
        static let screenHeight = Float(UIScreen.main.bounds.height)
    }
    
    struct Home {
        struct View {
            static let homeBackground       = "homeBackground.png"
            static let logo                 = "logo.png"
            static let welcomeText          = "welcomeText.png"
            static let mainButton           = "optimus.png"
            static let cancelButton         = "cancelButton.png"
            static let lightsButton         = "lightIcon.png"
            static let airConditionerButton = "airConditionerIcon.png"
            static let shoppingCartButton   = "shoppingCartIcon.png"
            static let fridgeButton         = "fridgeIcon.png"
        }
        
        struct SegueIdentifier {
            static let toLightVC            = "segue_HomeToLightVC"
            static let toAirConditionerVC   = "segue_HomeToAirConditionerVC"
            static let toShoppingCartVC     = "segue_HomeToShoppingCartVC"
            static let toFridgeVC           = "segue_HomeToFridgeVC"
        }
    }
    
    struct Lights {
        struct View {
            static let title                = "Lights"
            static let lightOn              = "lightOn.png"
            static let lightOff             = "lightOff.png"
        }
        
        struct Buttons {
            static let barButtonBrightness  = "Brightness"
            static let barButtonEdit        = "Edit"
        }
        
        struct SegueIdentifier {
            static let toBrightnessVC       = "segue_LightToBrightnessVC"
        }
    }
    
    struct Brightness {
        struct View {
            static let title                = "Adjust brightness"
            static let brightnessExample    = "brightnessAdjust.png"
        }
    }
    
    struct AirConditioner {
        struct View {
            static let title                = "Air Conditioners"
        }
    }
    
    struct ShoppingCart {
        struct View {
            static let title                = "Shopping Cart"
        }
    }
    
    struct Fridges {
        struct View {
            static let title                = "Fridges"
        }
    }
}
