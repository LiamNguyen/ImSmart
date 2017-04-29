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
    
    static let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    static let deviceName = UIDevice.current.name
    
    struct Window {
        static let screenWidth  = Float(UIScreen.main.bounds.width)
        static let screenHeight = Float(UIScreen.main.bounds.height)
    }
    
    struct Home {
        struct View {
            static let title                = "Home"
            static let homeBackground       = "homeBackground.png"
            static let logo                 = "logo.png"
            static let welcomeText          = "welcomeText.png"
            static let mainButton           = "optimus.png"
            static let cancelButton         = "cancelButton.png"
            static let lightsButton         = "lightIcon.png"
            static let airConditionerButton = "airConditionerIcon.png"
            static let shoppingCartButton   = "shoppingCartIcon.png"
            static let fridgeButton         = "fridgeIcon.png"
            static let homeButton           = "homeIcon.png"
            static var homeButtonSize       = (width: 40, height: 40)
            static var mainButtonPosition   = CGFloat(Constants.Window.screenHeight - 250)
        }
        
        struct Menu {
            static let title                = "Menu"
            static let waitingConnection    = "Joining network..."
            static let welcomeDevice        = "Welcome home"
            static let tcButton             = "Terms and Conditions"
            static let privacyStatement     = "Privacy Statement"
            static let version              = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
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
            static let backIcon             = "backIcon.png"
            static let snowFlake            = "snowFlake.png"
            static let tearDropIcon         = "tearDropIcon.png"
            static let sunIcon              = "sunIcon.png"
            static let standFanIcon         = "standFanIcon.png"
        }
        
        struct BarItem {
            static let back                 = "Home"
            static let areaLabel            = "Living Room"
        }
        
        struct segueIdentifier {
            static let toHomeVC             = "segue_AirConditionerToHomeVC"
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
    
    struct NotificationName {
        static let requiredUpdateLights     = "requiredUpdateLights"
    }
    
    struct HttpStatusCode {
        //    2XX Sucess
        
        static let success                  = 200
        static let created                  = 201
        static let accepted                 = 202
        static let noContent                = 204
        
        //    4XX Client Error
        
        static let badRequest               = 400
        static let unauthorized             = 401
        static let forbidden                = 403
        static let notFound                 = 404
        static let methodNotAllowed         = 405
        static let notAcceptable            = 406
        static let conflict                 = 409
        
        //    5XX Server Error
        
        static let internalServerError      = 500
        static let notImplemented           = 501
        static let badGateway               = 502
        static let gatewayTimeout           = 504
    }
}
