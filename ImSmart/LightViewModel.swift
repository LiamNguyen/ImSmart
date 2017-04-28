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
    var requireCellShake                    = Variable<Bool>(false)
    var requireSynchronization              = Variable<Bool>(false)
    var isReceiving                         = Variable<Bool>(false)
    var isFirstTimeGetLights                = Variable<Bool>(true)
    var allLights                           : Variable<[LightCellViewModel]>            = Variable([LightCellViewModel]())
    var selectedLights                      : Variable<[String: LightCellViewModel]>    = Variable([String: LightCellViewModel]())
    
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
        onReceiveRequireLightsUpdate()
    }
    
    func bindRx() {
        
        RemoteStore.sharedInstance.getAllLights(lightViewModel: self, completionHandler: { [weak self] allLights in
            self?.allLights.value               = allLights
            self?.isFirstTimeGetLights.value    = false
        })
        
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
            .subscribe(onNext: { [weak self] _ in
                guard let _ = self?.allLights.value, !(self?.isFirstTimeGetLights.value)! else {
                    return
                }
                let jsonObject = self?.buildJSONObject(fromLightCellViewModel: (self?.allLights.value)!)
                let jsonString = Helper.jsonStringify(jsonObject: jsonObject as AnyObject)
                
                RemoteStore.sharedInstance.updateAllLights(lights: jsonString, completionHandler: { success in
                    if success {
                        SocketIOManager.sharedInstance.requireUpdateLights()
                    } else {
                        print("Error when updating lights")
                    }
                })
            }).addDisposableTo(disposalBag)
    }
    
    private func onReceiveRequireLightsUpdate() {
        SocketIOManager.sharedInstance.onReceiveRequireLightsUpdate {
                self.isReceiving.value  = true
            RemoteStore.sharedInstance.getAllLights(lightViewModel: self, completionHandler: { [weak self] allLights in
                self?.allLights.value   = allLights
            })
        }
    }
    
    //** Mark: BUILD JSON OBJECT FROM ARRAY OF LIGHTS
    
    private func buildJSONObject(fromLightCellViewModel dataArray: [LightCellViewModel]) -> [[String: Any]] {
        return dataArray
            .map({ lightCellViewModel in
                return [
                    "isOn"      : lightCellViewModel.isOn.value,
                    "brightness": lightCellViewModel.brightness.value,
                    "area"      : lightCellViewModel.area.value
                ]
            })
    }
}
