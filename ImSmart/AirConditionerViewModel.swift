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
    
    fileprivate let disposalBag: DisposeBag = DisposeBag()
    
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        self.allAirConditioners     = Variable([AirConditionerCellViewModel]())
        self.currentAirConditioner  = Variable(AirConditionerCellViewModel())
        
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
        Observable.combineLatest(
            allAirConditioners.asObservable(),
            currentAirConditionerIndex.asObservable())
            .subscribe(onNext: { [weak self] _ in
                guard self!.allAirConditioners.value.count > 0 else {
                    return
                }
                self?.currentAirConditioner.value = self!.allAirConditioners.value[self!.currentAirConditionerIndex.value]
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
}
