//
//  LightCellViewModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /04/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxSwift

class LightCellViewModel {
    fileprivate let light                   : Light!
    fileprivate let requireCellShake        : Variable<Bool>!
    fileprivate let requireSynchronization  : Variable<Bool>!
    
    var isOn          : Variable<Bool>!
    var brightness    : Variable<Int>!
    var area          : Variable<String>!
    
    var cellMustShake : Observable<Bool>!
    
    private let disposalBag = DisposeBag()
    
    init(light: Light, requireCellShake: Variable<Bool>, requireSynchronization: Variable<Bool>) {
        self.light                  = light
        self.requireCellShake       = requireCellShake
        self.requireSynchronization = requireSynchronization
        self.isOn                   = Variable<Bool>(self.light.isOn)
        self.brightness             = Variable<Int>(self.light.brightness)
        self.area                   = Variable<String>(self.light.area)
        
        bindRx()
    }
    
    private func bindRx() {
        isOn.asObservable()
            .subscribe(onNext: { isOn in
                self.light.isOn = isOn
            }).addDisposableTo(disposalBag)
        
        brightness.asObservable()
            .filter({ _ in
                return self.isOn.value ? true : false
            })
            .subscribe(onNext: { brightness in
                self.light.brightness = brightness
            }).addDisposableTo(disposalBag)
        
        area.asObservable()
            .subscribe(onNext: { area in
                self.light.area = area
            }).addDisposableTo(disposalBag)
        
        cellMustShake = requireCellShake.asObservable()
            .map({ return $0 })
        
        let  _ = Observable.combineLatest(
            isOn.asObservable(),
            brightness.asObservable(),
            area.asObservable())
            .throttle(1.7, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.requireSynchronization.value = true
            })
    }
}
