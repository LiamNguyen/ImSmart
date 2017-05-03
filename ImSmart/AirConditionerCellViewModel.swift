//
//  AirConditionerCellViewModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /02/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxSwift

class AirConditionerCellViewModel {
    private var airConditioner                  : AirConditionerModel!
    private weak var airConditionerViewModel    : AirConditionerViewModel!
    
    var isOn        : Variable<Bool>!
    var fanSpeed    : Variable<String>!
    var swing       : Variable<String>!
    var mode        : Variable<String>!
    var temperature : Variable<Double>!
    var isTimerOn   : Variable<Bool>!
    var offTime     : Variable<NSDate>!
    var area        : Variable<String>!
    
    private var isReceiving     = false
    private var isRollingBack   = false
    private let disposalBag     = DisposeBag()
    
    init(airConditioner: AirConditionerModel, airConditionerViewModel: AirConditionerViewModel) {
        self.airConditioner             = airConditioner
        
        self.airConditionerViewModel    = airConditionerViewModel
        self.isOn                       = Variable<Bool>(self.airConditioner.isOn)
        self.fanSpeed                   = Variable<String>(self.airConditioner.fanSpeed)
        self.swing                      = Variable<String>(self.airConditioner.swing)
        self.mode                       = Variable<String>(self.airConditioner.mode)
        self.temperature                = Variable<Double>(self.airConditioner.temperature)
        self.isTimerOn                  = Variable<Bool>(self.airConditioner.isTimerOn)
        self.offTime                    = Variable<NSDate>(self.airConditioner.offTime)
        self.area                       = Variable<String>(self.airConditioner.area)
        
        bindRx()
    }
    
    init() {}
    
    private func bindRx() {
        isOn.asObservable()
            .subscribe(onNext: { [weak self] isOn in
                self?.airConditioner.isOn = isOn
            }).addDisposableTo(disposalBag)
        
        fanSpeed.asObservable()
            .subscribe(onNext: { [weak self] fanSpeed in
                self?.airConditioner.fanSpeed = fanSpeed
            }).addDisposableTo(disposalBag)
        
        swing.asObservable()
            .subscribe(onNext: { [weak self] swing in
                self?.airConditioner.swing = swing
            }).addDisposableTo(disposalBag)
        
        mode.asObservable()
            .subscribe(onNext: { [weak self] mode in
                self?.airConditioner.mode = mode
            }).addDisposableTo(disposalBag)
        
        temperature.asObservable()
            .subscribe(onNext: { [weak self] temperature in
                self?.airConditioner.temperature = temperature
            }).addDisposableTo(disposalBag)
        
        isTimerOn.asObservable()
            .subscribe(onNext: { [weak self] isTimerOn in
                self?.airConditioner.isTimerOn = isTimerOn
            }).addDisposableTo(disposalBag)
        
        offTime.asObservable()
            .subscribe(onNext: { [weak self] offTime in
                self?.airConditioner.offTime = offTime
            }).addDisposableTo(disposalBag)
        
        area.asObservable()
            .subscribe(onNext: { [weak self] area in
                self?.airConditioner.area = area
            }).addDisposableTo(disposalBag)
        
        airConditionerViewModel.isReceiving.asObservable()
            .bindNext { [weak self] isReceiving in
                self?.isReceiving = isReceiving
        }.addDisposableTo(disposalBag)
        
        airConditionerViewModel.isRollingBack.asObservable()
            .bindNext { [weak self] isRollingBack in
                self?.isRollingBack = isRollingBack
        }.addDisposableTo(disposalBag)
        
        Observable.combineLatest(
            isOn.asObservable(),
            fanSpeed.asObservable(),
            swing.asObservable(),
            mode.asObservable(),
            temperature.asObservable(),
            isTimerOn.asObservable(),
            offTime.asObservable(),
            area.asObservable())
        .throttle(0.4, scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            if self!.airConditionerViewModel.isFirstTimeGetAirConditioners.value {
                return
            }
            if self!.isReceiving {
                self?.isReceiving = !self!.isReceiving
                return
            }
            if self!.isRollingBack {
                self?.isRollingBack = !self!.isRollingBack
                return
            }
            self?.airConditionerViewModel.requireSynchronization.value = true
        }).addDisposableTo(disposalBag)
    }
}
