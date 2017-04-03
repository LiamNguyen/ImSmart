//
//  HomeViewController.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    private var homeViewModel       : HomeViewModel!
    
    private var mainButton          : UIButton!
    private var cancelButton        : UIButton!
    private var lightsButton        : UIButton!
    private var airConditionerButton: UIButton!
    private var fridgeButton        : UIButton!
    private var shoppingCartButton  : UIButton!
    private var mainButtonImageView : UIImageView!
    private var brandLogoImageView  : UIImageView!
    private var welcomeTextImageView: UIImageView!
    
    private let disposalBag         = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeViewModel = HomeViewModel()
     
        customizeAppearance()
        
        bindRxObserver()
        bindRxActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func bindRxObserver() {
//** Mark: BRAND LOGO
        
        self.homeViewModel.brandLogoOriginXObserver
            .subscribe(onNext: { brandLogoOriginX in
                UIView.animate(withDuration: 0.4, animations: {
                    self.brandLogoImageView.center.x = CGFloat(brandLogoOriginX)
                })
            }).addDisposableTo(disposalBag)
        
//** Mark: WELCOME TEXT
        
        self.homeViewModel.welcomeTextOriginXObserver
            .subscribe(onNext: { welcomeTextOriginX in
                UIView.animate(withDuration: 0.4, animations: {
                    self.welcomeTextImageView.center.x = CGFloat(welcomeTextOriginX)
                })
            }).addDisposableTo(disposalBag)
        
//** Mark: MAIN BUTTON
        
        self.homeViewModel.mainButtonSizeObserver
            .subscribe(onNext: { (width, height) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainButton.frame.size.width            = CGFloat(width)
                    self.mainButton.frame.size.height           = CGFloat(height)
                    self.mainButtonImageView.frame.size.width   = CGFloat(width)
                    self.mainButtonImageView.frame.size.height  = CGFloat(height)
                })
            }).addDisposableTo(disposalBag)
        
//** Mark: CANCEL BUTTON

        self.homeViewModel.cancelButtonSizeObserver
            .subscribe(onNext: { (width, height) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.cancelButton.frame.size.width  = CGFloat(width)
                    self.cancelButton.frame.size.height = CGFloat(height)
                })
            }).addDisposableTo(disposalBag)

//** Mark: LIGHT BUTTON

        self.homeViewModel.lightsButtonPositionObserver
            .subscribe(onNext: { lightsButtonCoordinate in
                UIView.animate(withDuration: 0.4, animations: {
                    self.lightsButton.center = CGPoint(
                        x: CGFloat(lightsButtonCoordinate.x),
                        y: CGFloat(lightsButtonCoordinate.y)
                    )
                })
            }).addDisposableTo(disposalBag)
        
//** Mark: AIR CONDITIONER BUTTON

        self.homeViewModel.airConditionerPositionObserver
            .subscribe(onNext: { airConditionerButtonCoordinate in
                UIView.animate(withDuration: 0.4, animations: {
                    self.airConditionerButton.center = CGPoint(
                        x: CGFloat(airConditionerButtonCoordinate.x),
                        y: CGFloat(airConditionerButtonCoordinate.y)
                    )
                })
            }).addDisposableTo(disposalBag)
        
//** Mark: SHOPPING CART BUTTON

        self.homeViewModel.shoppingCartButtonPositionObserver
            .subscribe(onNext: { shoppingCartButtonCoordinate in
                UIView.animate(withDuration: 0.4, animations: {
                    self.shoppingCartButton.center = CGPoint(
                        x: CGFloat(shoppingCartButtonCoordinate.x),
                        y: CGFloat(shoppingCartButtonCoordinate.y)
                    )
                })
            }).addDisposableTo(disposalBag)
        
//** Mark: FRIDGE BUTTON

        self.homeViewModel.fridgeButtonPositionObserver
            .subscribe(onNext: { fridgeButtonCoordinate in
                UIView.animate(withDuration: 0.4, animations: {
                    self.fridgeButton.center = CGPoint(
                        x: CGFloat(fridgeButtonCoordinate.x),
                        y: CGFloat(fridgeButtonCoordinate.y)
                    )
                })
            }).addDisposableTo(disposalBag)
    }
    
    private func bindRxActions() {
//** Mark: MAIN BUTTON

        self.mainButton
            .rx
            .tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.homeViewModel.isMainButtonShown.value = !(self?.homeViewModel.isMainButtonShown.value)!
            }).addDisposableTo(disposalBag)
        
//** Mark: CANCEL BUTTON

        self.cancelButton
            .rx
            .tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.homeViewModel.isMainButtonShown.value = !(self?.homeViewModel.isMainButtonShown.value)!
            }).addDisposableTo(disposalBag)
        
//** Mark: LIGHT BUTTON

        self.lightsButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.Home.SegueIdentifier.toLightVC, sender: self)
            }).addDisposableTo(disposalBag)
        
//** Mark: AIR CONDITIONER BUTTON
        
        self.airConditionerButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.Home.SegueIdentifier.toAirConditionerVC, sender: self)
            }).addDisposableTo(disposalBag)
        
//** Mark: SHOPPING CART BUTTON
        
        self.shoppingCartButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.Home.SegueIdentifier.toShoppingCartVC, sender: self)
            }).addDisposableTo(disposalBag)
        
//** Mark: FRIDGE BUTTON
        
        self.fridgeButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.Home.SegueIdentifier.toFridgeVC, sender: self)
            }).addDisposableTo(disposalBag)
    }
    
    private func customizeAppearance() {
        self.view.layer.contents = UIImage(named: Constants.Home.View.homeBackground)?.cgImage
        
        drawBrandLogo()
        drawWelcomeText()
        drawCancelButton()
        drawLightsButton()
        drawAirConditionerButton()
        drawShoppingCartButton()
        drawFridgeButton()
        drawMainButton()
    }
    
//** Mark: DRAWING BRAND LOGO

    private func drawBrandLogo() {
        let brandLogoImage                   = UIImage(named: Constants.Home.View.logo)
        
        self.brandLogoImageView              = UIImageView(image: brandLogoImage)
        self.brandLogoImageView.frame        = CGRect(x: 0, y: 0, width: 250, height: 100)
        self.brandLogoImageView.center       = CGPoint(x: UIScreen.main.bounds.width / 2, y: 120)
        self.brandLogoImageView.contentMode  = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.brandLogoImageView)
    }
    
//** Mark: DRAWING WELCOME TEXT

    private func drawWelcomeText() {
        let welcomeTextImage                   = UIImage(named: Constants.Home.View.welcomeText)
        
        self.welcomeTextImageView              = UIImageView(image: welcomeTextImage)
        self.welcomeTextImageView.frame        = CGRect(x: 0, y: 0, width: 320, height: 100)
        self.welcomeTextImageView.center       = CGPoint(x: UIScreen.main.bounds.width + 400, y: 120)
        self.welcomeTextImageView.contentMode  = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.welcomeTextImageView)
    }
    
//** Mark: DRAWING MAIN BUTTON

    private func drawMainButton() {
        self.mainButton                             = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        self.mainButton.frame                       = self.mainButton.bounds
        self.mainButton.center                      = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        UIFunctionality.applyShadow(toView: self.mainButton, withColor: UIColor.red)
        
        let buttonImage                             = UIImage(named: Constants.Home.View.mainButton)
        
        self.mainButtonImageView                    = UIImageView(image: buttonImage)
        self.mainButtonImageView.frame              = CGRect(x: 0, y: 0, width: 110, height: 110)
        self.mainButtonImageView.center             = CGPoint(x: mainButton.frame.size.width / 2, y: mainButton.frame.size.height / 2)
        self.mainButtonImageView.contentMode        = UIViewContentMode.scaleToFill
        self.mainButtonImageView.clipsToBounds      = true
        self.mainButtonImageView.layer.cornerRadius = 10
        
        self.mainButton.addSubview(mainButtonImageView)
        self.view.addSubview(self.mainButton)
    }
    
//** Mark: DRAWING CANCEL BUTTON
    
    private func drawCancelButton() {
        let cancelButtonImage               = UIImage(named: Constants.Home.View.cancelButton)?.cgImage
        
        self.cancelButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.cancelButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        self.cancelButton.layer.contents    = cancelButtonImage

        self.view.addSubview(self.cancelButton)
    }
    
//** Mark: DRAWING LIGHT BUTTON
    
    private func drawLightsButton() {
        let lightsButtonImage               = UIImage(named: Constants.Home.View.lightsButton)?.cgImage
        
        self.lightsButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.lightsButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        self.lightsButton.layer.contents    = lightsButtonImage
        
        self.view.addSubview(self.lightsButton)
    }
    
//** Mark: DRAWING ARI CONDITIONER BUTTON
    
    private func drawAirConditionerButton() {
        let airConditionerButtonImage               = UIImage(named: Constants.Home.View.airConditionerButton)?.cgImage
        
        self.airConditionerButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.airConditionerButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        self.airConditionerButton.layer.contents    = airConditionerButtonImage
        
        self.view.addSubview(self.airConditionerButton)
    }
    
//** Mark: DRAWING SHOPPING CART BUTTON
    
    private func drawShoppingCartButton() {
        let shoppingCartButtonImage               = UIImage(named: Constants.Home.View.shoppingCartButton)?.cgImage
        
        self.shoppingCartButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.shoppingCartButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        self.shoppingCartButton.layer.contents    = shoppingCartButtonImage
        
        self.view.addSubview(self.shoppingCartButton)
    }
    
//** Mark: DRAWING FRIDGE BUTTON
    
    private func drawFridgeButton() {
        let fridgeButtonImage               = UIImage(named: Constants.Home.View.fridgeButton)?.cgImage
        
        self.fridgeButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.fridgeButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        self.fridgeButton.layer.contents    = fridgeButtonImage
        
        self.view.addSubview(self.fridgeButton)
    }
    
}
