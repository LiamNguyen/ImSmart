//
//  AirConditionerViewModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /02/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import ObjectMapper

class AirConditionerViewModel {
    var requireSynchronization          : Variable<Bool> = Variable<Bool>(false)
    var isReceiving                     : Variable<Bool> = Variable<Bool>(false)
    var isRollingBack                   : Variable<Bool> = Variable<Bool>(false)
    var isFirstTimeGetAirConditioners   : Variable<Bool> = Variable<Bool>(true)
    var isHavingServerError             : Variable<Bool> = Variable<Bool>(false)
    var isFailedToUpdate                : Variable<Bool> = Variable<Bool>(false)
    var currentAirConditionerIndex      : Variable<Int>  = Variable<Int>(0)
    var allAirConditioners              : Variable<[AirConditionerCellViewModel]>!
    var currentAirConditioner           : Variable<AirConditionerCellViewModel>!
    
    var loadingViewAlphaObservable      : Observable<Float>!
    var activityIndicatorShouldSpin     : Observable<Bool>!
    
    fileprivate let disposalBag: DisposeBag = DisposeBag()
    
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        self.allAirConditioners = Variable([AirConditionerCellViewModel]())
        
        getAllAirConditioners()
        bindRx()
        
//        **MARK: NOTIFICATION OBSERVERS
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: Constants.NotificationName.requiredUpdateAirCons),
            object: nil,
            queue: nil) { [weak self] _ in
                self?.isReceiving.value = true
                self?.getAllAirConditioners()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Air conditioner view model -> Dead")
    }
    
    private func bindRx() {
        loadingViewAlphaObservable = isFirstTimeGetAirConditioners.asObservable()
            .map({ isFirstTimeGetAirConditioners in
                return isFirstTimeGetAirConditioners ? 1 : 0
            })
        
        activityIndicatorShouldSpin = isFirstTimeGetAirConditioners.asObservable()
            .map({ return $0 })
        
        Observable.combineLatest(
            allAirConditioners.asObservable(),
            currentAirConditionerIndex.asObservable())
            .subscribe(onNext: { [weak self] _ in
                guard self!.isAllAirConditionerHasValue() else {
                    return
                }
                
                let itemAtIndexOfAllAirConditioners = self!.allAirConditioners.value[self!.currentAirConditionerIndex.value]
                
                if self?.currentAirConditioner == nil {
                    self?.currentAirConditioner = Variable(itemAtIndexOfAllAirConditioners)
                } else {
                    self?.currentAirConditioner.value = itemAtIndexOfAllAirConditioners
                }
            }).addDisposableTo(disposalBag)
    }
    
    func getAllAirConditioners() {
        RemoteStore.sharedInstance.getAllAirConditioners { [weak self] (allAirConditioners, error) in
            if let _ = error {
                self?.isHavingServerError.value = true
                return
            }

            self?.allAirConditioners.value = allAirConditioners.map({ airConditioner -> AirConditionerCellViewModel in
                return AirConditionerCellViewModel(airConditioner: airConditioner, airConditionerViewModel: self!)
            })
            self?.isHavingServerError.value = false
            if self!.isFirstTimeGetAirConditioners.value {
                self?.isFirstTimeGetAirConditioners.value = false
            }
        }
    }
    
    func isAllAirConditionerHasValue() -> Bool {
        return self.allAirConditioners.value.count > 0
    }
}
