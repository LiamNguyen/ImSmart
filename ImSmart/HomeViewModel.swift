
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
    var brandLogoOriginXObserver            : Observable<Float>!
    var welcomeTextOriginXObserver          : Observable<Float>!
    var mainButtonSizeObserver              : Observable<(Int, Int)>!
    var cancelButtonSizeObserver            : Observable<(Int, Int)>!
    var lightsButtonPositionObserver        : Observable<(x: Float, y: Float)>!
    var airConditionerPositionObserver      : Observable<(x: Float, y: Float)>!
    var shoppingCartButtonPositionObserver  : Observable<(x: Float, y: Float)>!
    var fridgeButtonPositionObserver        : Observable<(x: Float, y: Float)>!
    var connectionsLabelObserver            : Observable<String>!
    var menuViewOriginXObserver             : Observable<Float>!
    var activityIndicatorShouldSpin         : Observable<Bool>!
    
    fileprivate var disposalBag                 = DisposeBag()
    
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
        
        lightsButtonPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .origin) : self.buttonsCoordinate(.light)
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
        
        if position == .origin {
            return originCoordinate
        }
        
        switch buttonType {
        case .light:
            return (
                originCoordinate.x - 65,
                originCoordinate.y - 65
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
        default:
            return (
                originCoordinate.x + 65,
                originCoordinate.y + 65
            )
        }
    }
    
    fileprivate enum ButtonType {
        case light
        case airConditioner
        case shoppingCart
        case fridge
        case `default`
    }
    
    fileprivate enum ButtonPosition {
        case origin
        case destination
    }
}
