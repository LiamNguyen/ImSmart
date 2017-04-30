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
    var isHavingServerError                 = Variable<Bool>(false)
    var allLights                           : Variable<[LightCellViewModel]>!
    var selectedLights                      : Variable<[String: LightCellViewModel]>!
    
    var viewColorObserver                   : Observable<UIColor>!
    var tableViewColorObserver              : Observable<UIColor>!
    var tableViewBottomConstraintObserver   : Observable<Float>!
    var cellContentViewColorObserver        : Observable<UIColor>!
    var cancelSelectionViewOriginYObserver  : Observable<Float>!
    var barButtonTitleObserver              : Observable<String>!
    var barButtonEnableObserver             : Observable<Bool>!
    var activityIndicatorShouldSpin         : Observable<Bool>!
    
    var brightnessValue                     = Variable<Float>(0.0)
    var sampleLightBrightness               : Observable<UIColor>!
    
    private let disposalBag                 = DisposeBag()
    
    init() {
        self.allLights      = Variable([LightCellViewModel]())
        self.selectedLights = Variable([String: LightCellViewModel]())

        bindRx()
        
//        **MARK: NOTIFICATION OBSERVERS
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: Constants.NotificationName.requiredUpdateLights),
            object: nil,
            queue: nil) { [weak self] _ in
                self?.isReceiving.value = true
                self?.getAllLights()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Light view model -> Dead")
    }
    
    func bindRx() {
        getAllLights()
        
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
        
        activityIndicatorShouldSpin = Observable.combineLatest(
            isFirstTimeGetLights.asObservable(),
            isHavingServerError.asObservable()
        ).map({ (isFirstTimeGetLights, isHavingServerError) in
            return isFirstTimeGetLights && !isHavingServerError
        })
        
        requireSynchronization.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let _ = self?.isFirstTimeGetLights.value, let _ = self?.allLights.value, let _ = self?.buildJSONObject(fromLightCellViewModel: (self?.allLights.value)!) else {
                    print("ERROR: Self is nil")
                    return
                }
                guard let _ = self?.allLights.value, !self!.isFirstTimeGetLights.value else {
                    print("Lights is not fetched or this is the first time getting lights")
                    return
                }
                let jsonObject = self!.buildJSONObject(fromLightCellViewModel: (self?.allLights.value)!)
                let jsonString = Helper.jsonStringify(jsonObject: jsonObject as AnyObject)
                
                RemoteStore.sharedInstance.updateAllLights(lights: jsonString, completionHandler: { success in
                    if success {
                        SocketIOManager.sharedInstance.requireUpdateLights()
                    } else {
                        print("ERROR: Error when updating lights")
                    }
                })
            }).addDisposableTo(disposalBag)
    }
    
    func getAllLights() {
        RemoteStore.sharedInstance.getAllLights(completionHandler: { [weak self] (allLights, error) in
            if !error.isEmpty {
                self?.isHavingServerError.value = true
                return
            }
            guard let _ = self?.parseJSONToLightCellViewModel(json: allLights) else {
                print("ERROR: Self is nil")
                return
            }
            self?.allLights.value               = self!.parseJSONToLightCellViewModel(json: allLights)
            self?.isHavingServerError.value     = false
            if self!.isFirstTimeGetLights.value {
                self?.isFirstTimeGetLights.value = false
            }
        })
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
    
    //** Mark: PARSE JSON TO MODEL AND RETURN ARRAY OF LIGHTS
    
    private func parseJSONToLightCellViewModel(json: NSArray) -> [LightCellViewModel] {
        let receivedAllLights = json.map({ item -> LightCellViewModel in
            let dictionary = item as? NSDictionary
            let light = Light(
                brightness  : dictionary?["Brightness"] as? Int ?? 0,
                area        : dictionary?["Area"] as? String ?? "",
                isOn        : dictionary?["IsOn"] as? Bool ?? false
            )
            return LightCellViewModel(light: light, lightViewModel: self)
        })
        return receivedAllLights
    }
}
