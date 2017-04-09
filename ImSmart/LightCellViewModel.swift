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
    fileprivate let light: Light!
    fileprivate let lightViewModel: LightViewModel!
    
    var isOn          = Variable<Bool>(false)
    var brightness    : Variable<Int>!
    var area          : Variable<String>!
    
    var cellMustShake : Observable<Bool>!
    
    private let disposalBag = DisposeBag()
    
    init(light: Light, parentViewModel: LightViewModel) {
        self.light          = light
        self.lightViewModel = parentViewModel
        
        self.brightness     = Variable<Int>(self.light.brightness)
        self.area           = Variable<String>(self.light.area)
        
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
        
        cellMustShake = lightViewModel.requireCellShake.asObservable()
            .map({ return $0 })
    }
}