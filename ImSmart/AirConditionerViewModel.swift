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

class AirConditionerViewModel {
    var requireSynchronization          : Variable<Bool> = Variable<Bool>(false)
    var isReceiving                     : Variable<Bool> = Variable<Bool>(false)
    var isRollingBack                   : Variable<Bool> = Variable<Bool>(false)
    var isFirstTimeGetAirConditioners   : Variable<Bool> = Variable<Bool>(true)
    var isHavingServerError             : Variable<Bool> = Variable<Bool>(false)
    var isFailedToUpdate                : Variable<Bool> = Variable<Bool>(false)
    var allAirConditioners              : Variable<[AirConditionerCellViewModel]>!
    var currentAirConditioner           : Variable<AirConditionerCellViewModel>!
    
    private let disposalBag: DisposeBag = DisposeBag()
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        self.allAirConditioners = Variable([AirConditionerCellViewModel]())
        
//        bindRx()
        
//        **MARK: NOTIFICATION OBSERVERS
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: Constants.NotificationName.requiredUpdateAirCons),
            object: nil,
            queue: nil) { [weak self] _ in
                self?.isReceiving.value = true
//                self?.getAllAirConditioners()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Air conditioner view model -> Dead")
    }
}
