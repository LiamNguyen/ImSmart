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
    private var light               : Light!
    private weak var lightViewModel : LightViewModel!
    
    var isOn          : Variable<Bool>!
    var brightness    : Variable<Int16>!
    var area          : Variable<String>!
    
    var cellMustShake : Observable<Bool>!

    private var isReceiving = false
    private let disposalBag = DisposeBag()
    
    init(light: Light, lightViewModel: LightViewModel) {
        self.light                  = light
        
        self.lightViewModel         = lightViewModel
        self.isOn                   = Variable<Bool>(self.light.isOn)
        self.brightness             = Variable<Int16>(self.light.brightness)
        self.area                   = Variable<String>(self.light.area!)
        
        bindRx()
    }
    
    private func bindRx() {
        isOn.asObservable()
            .subscribe(onNext: { [weak self] isOn in
                self?.light.isOn = isOn
            }).addDisposableTo(disposalBag)
        
        brightness.asObservable()
            .filter({ [weak self] _ in
                return (self?.isOn.value)! ? true : false
            })
            .subscribe(onNext: { [weak self] brightness in
                self?.light.brightness = brightness
            }).addDisposableTo(disposalBag)
        
        area.asObservable()
            .subscribe(onNext: { [weak self] area in
                self?.light.area = area
            }).addDisposableTo(disposalBag)
        
        lightViewModel.isReceiving.asObservable()
            .bindNext { [weak self] isReceiving in
                self?.isReceiving = isReceiving
        }.addDisposableTo(disposalBag)
        
        cellMustShake = lightViewModel.requireCellShake.asObservable()
            .map({ return $0 })
        
        Observable.combineLatest(
            isOn.asObservable(),
            brightness.asObservable(),
            area.asObservable())
            .throttle(2.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if (self?.lightViewModel.isFirstTimeGetLights.value)! {
                    return
                }
                if (self?.isReceiving)! {
                    self?.isReceiving = !(self?.isReceiving)!
                    return
                }
                self?.lightViewModel.requireSynchronization.value = true
            }).addDisposableTo(disposalBag)
    }
}
