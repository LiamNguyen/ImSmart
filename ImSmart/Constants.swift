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
    
    static let deviceUUID:String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    static let deviceName:String = UIDevice.current.name
    static var longTextLineNumbers: Int = {
        return Constants.DeviceModel.deviceType() == .iPhone5 || Constants.DeviceModel.deviceType() == .iPhone4 ? 3 : 2
    }()
    
    struct Window {
        static let screenWidth: Float  = Float(UIScreen.main.bounds.width)
        static let screenHeight: Float = Float(UIScreen.main.bounds.height)
    }
    
    struct DeviceModel {
        static func deviceType() -> DeviceType {
            switch Constants.Window.screenHeight {
            case 480:
                return .iPhone4
            case 568:
                return .iPhone5
            case 667:
                return .iPhone6
            case 736:
                return .iPhone6Plus
            case 1024:
                return .iPadMini
            case 1366:
                return .iPadPro
            default:
                print("Undefined device type")
                return .iPhone6
            }
        }
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
            static let addButton            = "addIcon.png"
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
            static let toAddLightVc         = "segue_HomeToAddLightVC"
        }
    }
    
    struct Lights {
        struct View {
            static let title                = "Lights"
            static let lightOn              = "lightOn.png"
            static let lightOff             = "lightOff.png"
            static let refreshIcon          = "refreshIcon.png"
        }
        
        struct Buttons {
            static let barButtonBrightness  = "Brightness"
            static let barButtonEdit        = "Edit"
        }
        
        struct SegueIdentifier {
            static let toBrightnessVC       = "segue_LightToBrightnessVC"
        }
        
        struct Message {
            static let serverError          = "Server error. Please check internet connection or contact customer service to get support"
        }
    }
    
    struct AddLight {
        struct AlertView {
            static let title                : String = "Found light"
            static let message              : String = "Light Id: "
            static let textFieldPlaceHolder : String = "Where is this light located?"
            
            struct CancelAction {
                static let title: String    = "Cancel"
            }
            
            struct AddAction {
                static let title: String    = "Add"
            }
        }
        
        struct SegueIdentifier {
            static let toLightVC        = "segue_AddLightToLightVC"
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
            static let loadingLabel         = "Loading..."
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
        
        struct FanSpeed {
            static let high                 = "HI"
            static let medium               = "MED"
            static let low                  = "LO"
        }
        
        struct Swing {
            static let left                 = "LEFT"
            static let middle               = "MID"
            static let right                = "RIGHT"
            static let auto                 = "AUTO"
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
        static let requiredUpdateAirCons    = "requiredUpdateAirCons"
    }
    
    struct UserNotification {
        struct EnterRegion {
            static let identifier           = "enterRegion"
            static let title                = "Almost home"
            static let body                 = "Heat up your room?"
        }
        
        struct ExitRegion {
            static let identifier           = "exitRegion"
            static let title                = "Forget something?"
            static let body                 = "Turn some running đevices off?"
        }
    }
    
    struct Coordinate {
        static let Home                     = (latitude: 60.207943, longitude: 24.663332, identifier: "Home")
    }
    
    struct Location {
        static let radius                   = 1.0
    }
    
    struct Beacon {
        static let TestBeacon: (minor: UInt16, major: UInt16, proximityId: String) = (
            minor: 0001,
            major: 0001,
            proximityId: "135A1D6C-0B9F-482A-9944-33E230D8AF05"
        )
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
    
    public enum DeviceType {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPadMini
        case iPadPro
    }
}
