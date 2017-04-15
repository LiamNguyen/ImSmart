//
//  LightViewModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /08/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LightViewModel {
    var dataSynchronizeManager              : DataSynchronizationManager!
    
    var requireCellShake                    = Variable<Bool>(false)
    var requireSynchronization              = Variable<Bool>(false)
    var mockupLights                        : Variable<[LightCellViewModel]>!
    var selectedLights                      = Variable<[String: LightCellViewModel]>([String: LightCellViewModel]())
    
    var viewColorObserver                   : Observable<UIColor>!
    var tableViewColorObserver              : Observable<UIColor>!
    var tableViewBottomConstraintObserver   : Observable<Float>!
    var cellContentViewColorObserver        : Observable<UIColor>!
    var cancelSelectionViewOriginYObserver  : Observable<Float>!
    var barButtonTitleObserver              : Observable<String>!
    var barButtonEnableObserver             : Observable<Bool>!
    
    var brightnessValue                     = Variable<Float>(0.0)
    var sampleLightBrightness               : Observable<UIColor>!
    
    private let disposalBag                 = DisposeBag()
    
    init() {
        bindRx()
    }
    
    convenience init(dataSynchronizeManager: DataSynchronizationManager) {
        self.init()
        self.dataSynchronizeManager             = dataSynchronizeManager
        self.dataSynchronizeManager.delegate    = self
    }
    
    func bindRx() {
        mockupLights = Variable(LightsMockup.lights(requireCellShake: requireCellShake, requireSynchronization: requireSynchronization))
        
        viewColorObserver = requireCellShake.asObservable()
            .map({ requireCellShake in
                return requireCellShake ? Theme.contentHighlighted : Theme.background
            })
        
        tableViewColorObserver = requireCellShake.asObservable()
            .map({ requireCellShake in
                return requireCellShake ? Theme.contentHighlighted : Theme.background
            })
        
        tableViewBottomConstraintObserver = requireCellShake.asObservable()
            .map({ requireCellShake in
                return requireCellShake ? 60 : 8
            })
        
        cellContentViewColorObserver = requireCellShake.asObservable()
            .map({ requireCellShake in
                return requireCellShake ? Theme.contentHighlighted : Theme.background
            })
        
        cancelSelectionViewOriginYObserver = requireCellShake.asObservable()
            .map({ requireCellShake in
                return requireCellShake ? Constants.Window.screenHeight - 30 : Constants.Window.screenHeight + 30
            })
        
        barButtonTitleObserver = requireCellShake.asObservable()
            .map({ requireCellShake in
                return requireCellShake ? Constants.Lights.Buttons.barButtonEdit : Constants.Lights.Buttons.barButtonBrightness
            })
        
        sampleLightBrightness = brightnessValue.asObservable()
            .map({ brightnessValue in
                return UIColor(
                    red: 255 / 255,
                    green: 255 / 255,
                    blue: CGFloat((100 - brightnessValue) * 2.55) / 255,
                    alpha: 1
                )
            })
        
        barButtonEnableObserver = Observable.combineLatest(
            requireCellShake.asObservable(),
            selectedLights.asObservable()) { (requireCellShake, selectedLights) in
                return requireCellShake ? !selectedLights.values.isEmpty : true
        }
        
        requireSynchronization.asObservable()
            .subscribe(onNext: { _ in
                guard let _ = self.dataSynchronizeManager else {
                    return
                }
                let jsonObject = Helper.buildJSONObject(fromLightCellViewModel: (self.mockupLights.value))
                let jsonString = Helper.jsonStringify(jsonObject: jsonObject as AnyObject)
                
                self.dataSynchronizeManager?.senđData(dataToBeSent: jsonString)
            }).addDisposableTo(disposalBag)
    }
    
    
}

extension LightViewModel: DataSynchronizationManagerDelegate {
    func connectedDevicesChanged(manager: DataSynchronizationManager, connectedDevices: [String]) {
        NSLog("%@", "Connections: \(connectedDevices)")
    }
    
    func onDataReceived(manager: DataSynchronizationManager, data: Any) {
        mockupLights.value = data as! [LightCellViewModel]
    }
}
