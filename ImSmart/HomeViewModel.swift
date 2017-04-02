//
//  HomeViewModel.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
    
    var isMainButtonShown: Variable<Bool> = Variable(true)
    var brandLogoOriginXObserver: Observable<Float>!
    var welcomeTextOriginXObserver: Observable<Float>!
    var mainButtonSizeObserver: Observable<(Int, Int)>!
    var cancelButtonSizeObserver: Observable<(Int, Int)>!
    
    private var disposalBag = DisposeBag()
    
    init() {
        bindRx()
    }
    
    private func bindRx() {
        brandLogoOriginXObserver = isMainButtonShown.asObservable()
            .map ({ isMainButtonShown in
                return isMainButtonShown ? Constants.Window.screenWidth / 2 : -(Constants.Window.screenWidth)
            })
        
        welcomeTextOriginXObserver = isMainButtonShown.asObservable()
            .map({ isMainButtonShown in
                return isMainButtonShown ? Constants.Window.screenWidth + 400 : Constants.Window.screenWidth / 2
            })
        
        mainButtonSizeObserver = isMainButtonShown.asObservable()
            .map({ (isMainButtonShown) in
                return isMainButtonShown ? (120, 120) : (0, 0)
            })
        
        cancelButtonSizeObserver = isMainButtonShown.asObservable()
            .map({ (isMainButtonShown) in
                return isMainButtonShown ? (0, 0) : (40, 40)
            })
    }
    
}
