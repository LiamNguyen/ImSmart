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
    var dataSynchronizeManager              : DataSynchronizationManager?
    
    var isMainButtonShown                   : Variable<Bool>        = Variable(true)
    var connectedDevices                    : Variable<[String]>    = Variable([String]())
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
    
    private var disposalBag                 = DisposeBag()
    
    init() {
        dataSynchronizeManager              = DataSynchronizationManager()
        dataSynchronizeManager?.delegate    = self
        bindRx()
    }
    
    private func bindRx() {
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
                return isMainButtonShown ? self.buttonsCoordinate(position: .Origin) : self.buttonsCoordinate(buttonType: .Light)
            })
        
        airConditionerPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .Origin) : self.buttonsCoordinate(buttonType: .AirConditioner)
            })
        
        shoppingCartButtonPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .Origin) : self.buttonsCoordinate(buttonType: .ShoppingCart)
            })
        
        fridgeButtonPositionObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? self.buttonsCoordinate(position: .Origin) : self.buttonsCoordinate(buttonType: .Fridge)
            })
        
        connectionsLabelObserver = connectedDevices.asObservable()
            .map({ connectedDevices in
                return connectedDevices.isEmpty ? Constants.Home.Menu.waitingConnections : Constants.Home.Menu.connectionsLabel
            })
        
        menuViewOriginXObserver = menuViewShouldShow.asObservable()
            .map({ menuViewShouldShow in
                return menuViewShouldShow ? Constants.Window.screenWidth - 135 : Constants.Window.screenWidth + 135
            })
        
        activityIndicatorShouldSpin = Observable.combineLatest(
            connectedDevices.asObservable(),
            menuViewShouldShow.asObservable(), resultSelector: { (connectedDevices, menuViewShouldShow) -> Bool in
                return connectedDevices.isEmpty && menuViewShouldShow
        })
    }
    
    private func buttonsCoordinate(buttonType: ButtonType = .Default, position: ButtonPosition = .Destination) -> (Float, Float) {
        let screenWidth = Constants.Window.screenWidth
        let originCoordinate = (
            x: Float(screenWidth / 2),
            y: Float(Constants.Home.View.mainButtonPosition)
        )
        
        if position == .Origin {
            return originCoordinate
        }
        
        switch buttonType {
        case .Light:
            return (
                originCoordinate.x - 65,
                originCoordinate.y - 65
            )
        case .AirConditioner:
            return (
                originCoordinate.x + 65,
                originCoordinate.y - 65
            )
        case .ShoppingCart:
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
    
    private enum ButtonType {
        case Light
        case AirConditioner
        case ShoppingCart
        case Fridge
        case Default
    }
    
    private enum ButtonPosition {
        case Origin
        case Destination
    }
}

extension HomeViewModel: DataSynchronizationManagerDelegate {
    func connectedDevicesChanged(manager: DataSynchronizationManager, connectedDevices: [String]) {
        self.connectedDevices.value = connectedDevices
    }
    
    func onDataReceived(manager: DataSynchronizationManager, data: Any) {
        
    }
}
