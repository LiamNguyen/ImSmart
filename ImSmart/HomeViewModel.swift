
//
//  HomeViewModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel{
    
    var localStore                          : LocalStore!
    
    var isMainButtonShown                   : Variable<Bool>        = Variable(true)
    var menuViewShouldShow                  : Variable<Bool>        = Variable(false)
    var isAddLightButtonShown               : Variable<Bool>        = Variable(false)
    var brandLogoOriginXObserver            : Observable<Float>!
    var welcomeTextOriginXObserver          : Observable<Float>!
    var mainButtonSizeObserver              : Observable<(Int, Int)>!
    var cancelButtonSizeObserver            : Observable<(Int, Int)>!
    var lightsButtonPositionObserver        : Observable<(x: Float, y: Float)>!
    var addLightButtonPositionObserver      : Observable<(x: Float, y: Float)>!
    var airConditionerPositionObserver      : Observable<(x: Float, y: Float)>!
    var shoppingCartButtonPositionObserver  : Observable<(x: Float, y: Float)>!
    var fridgeButtonPositionObserver        : Observable<(x: Float, y: Float)>!
    var connectionsLabelObserver            : Observable<String>!
    var menuViewOriginXObserver             : Observable<Float>!
    var activityIndicatorShouldSpin         : Observable<Bool>!
    
    fileprivate var disposalBag             = DisposeBag()
    
    init() {
        bindRx()
    }
    
    fileprivate func bindRx() {
        brandLogoOriginXObserver = isMainButtonShown.asObservable()
            .map ({ isMainButtonShown in
                return isMainButtonShown ? Constants.Window.screenWidth / 2 : -(Constants.Window.screenWidth)
            })
        
        welcomeTextOriginXObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? Constants.Window.screenWidth + 400 : Constants.Window.screenWidth / 2
            })
        
        mainButtonSizeObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? (120, 120) : (0, 0)
            })
        
        cancelButtonSizeObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? (0, 0) : (40, 40)
            })
        
        lightsButtonPositionObserver = Observable.combineLatest(
            isMainButtonShown.asObservable(),
            isAddLightButtonShown.asObservable())
            .map({ (isMainButtonShown, isAddLightButtonShown) in
                if isMainButtonShown {
                    return self.buttonsCoordinate(position: .origin)
                } else {
                    return isAddLightButtonShown ? self.buttonsCoordinate(.light, position: .addLightShownDestination) : self.buttonsCoordinate(.light)
                }
            })
        
        addLightButtonPositionObserver = isAddLightButtonShown.asObservable()
            .map({ isAddLightButtonShown in
                return isAddLightButtonShown ? self.buttonsCoordinate(.addLight) : self.buttonsCoordinate(.addLight, position: .origin)
            })
        
        airConditionerPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .origin) : self.buttonsCoordinate(.airConditioner)
            })
        
        shoppingCartButtonPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .origin) : self.buttonsCoordinate(.shoppingCart)
            })
        
        fridgeButtonPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .origin) : self.buttonsCoordinate(.fridge)
            })
        
        connectionsLabelObserver = SocketIOManager.sharedInstance.isDeviceConnectedToSocket.asObservable()
            .map({ isDeviceConnected in
                return isDeviceConnected ? Constants.Home.Menu.welcomeDevice : Constants.Home.Menu.waitingConnection
            })
        
        menuViewOriginXObserver = menuViewShouldShow.asObservable()
            .map({ menuViewShouldShow in
                return menuViewShouldShow ? Constants.Window.screenWidth - 135 : Constants.Window.screenWidth + 135
            })
        
        activityIndicatorShouldSpin = Observable.combineLatest(
            SocketIOManager.sharedInstance.isDeviceConnectedToSocket.asObservable(),
            menuViewShouldShow.asObservable(), resultSelector: { (isDeviceConnected, menuViewShouldShow) -> Bool in
                return !isDeviceConnected && menuViewShouldShow
        })
    }
    
    fileprivate func buttonsCoordinate(_ buttonType: ButtonType = .default, position: ButtonPosition = .destination) -> (Float, Float) {
        let screenWidth = Constants.Window.screenWidth
        let originCoordinate = (
            x: Float(screenWidth / 2),
            y: Float(Constants.Home.View.mainButtonPosition)
        )
        
        let addLightButtonOriginCoordinate = (
            x: originCoordinate.x - 65,
            y: originCoordinate.y - 65
        )
        
        if position == .origin {
            return buttonType == .addLight ? addLightButtonOriginCoordinate : originCoordinate
        }
        
        switch buttonType {
        case .light:
            return position == .addLightShownDestination ? (
                originCoordinate.x - 90,
                originCoordinate.y - 30
            ) : (
                originCoordinate.x - 65,
                originCoordinate.y - 65
            )
        case .addLight:
            return (
                originCoordinate.x - 30,
                originCoordinate.y - 90
            )
        case .airConditioner:
            return (
                originCoordinate.x + 65,
                originCoordinate.y - 65
            )
        case .shoppingCart:
            return (
                originCoordinate.x - 65,
                originCoordinate.y + 65
            )
        case .fridge:
            return (
                originCoordinate.x + 65,
                originCoordinate.y + 65
            )
        default:
            return (0, 0)
        }
    }
    
    fileprivate enum ButtonType {
        case light
        case addLight
        case airConditioner
        case shoppingCart
        case fridge
        case `default`
    }
    
    fileprivate enum ButtonPosition {
        case origin
        case destination
        case addLightShownDestination
    }
}
