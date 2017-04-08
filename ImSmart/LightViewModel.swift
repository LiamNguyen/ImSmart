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
    var selectedLights                      = Variable<[String: LightCellViewModel]>([String: LightCellViewModel]())
    
    var viewColorObserver                   : Observable<UIColor>!
    var tableViewColorObserver              : Observable<UIColor>!
    var tableViewBottomConstraintObserver   : Observable<Float>!
    var cellContentViewColorObserver        : Observable<UIColor>!
    var cancelSelectionViewOriginYObserver  : Observable<Float>!
    var barButtonTitleObserver              : Observable<String>!
    
    init() {
        bindRx()
    }
    
    func bindRx() {
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
    }
}
