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
    
    private var homeViewModel: HomeViewModel!
    
    private var mainButton: UIButton!
    private var cancelButton: UIButton!
    private var mainButtonImageView: UIImageView!
    private var brandLogoImageView: UIImageView!
    private var welcomeTextImageView: UIImageView!
    
    private let disposalBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeViewModel = HomeViewModel()
     
        customizeAppearance()

        bindRx()
    }
    
    private func customizeAppearance() {
        self.view.layer.contents = UIImage(named: Constants.Home.View.homeBackground)?.cgImage
        
        drawBrandLogo()
        drawWelcomeText()
        drawMainButton()
        drawCancelButton()
    }
    
    private func drawBrandLogo() {
        let brandLogoImage                   = UIImage(named: Constants.Home.View.logo)
        self.brandLogoImageView              = UIImageView(image: brandLogoImage)
        self.brandLogoImageView.frame        = CGRect(x: 0, y: 0, width: 250, height: 100)
        self.brandLogoImageView.center       = CGPoint(x: UIScreen.main.bounds.width / 2, y: 120)
        self.brandLogoImageView.contentMode  = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.brandLogoImageView)
    }
    
    private func drawWelcomeText() {
        let welcomeTextImage                   = UIImage(named: Constants.Home.View.welcomeText)
        self.welcomeTextImageView              = UIImageView(image: welcomeTextImage)
        self.welcomeTextImageView.frame        = CGRect(x: 0, y: 0, width: 320, height: 100)
        self.welcomeTextImageView.center       = CGPoint(x: UIScreen.main.bounds.width + 400, y: 120)
        self.welcomeTextImageView.contentMode  = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.welcomeTextImageView)
    }
    
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
    
    private func drawCancelButton() {
        let cancelButtonImage               = UIImage(named: Constants.Home.View.cancelButton)?.cgImage
        
        self.cancelButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.cancelButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: 420)
        self.cancelButton.layer.contents    = cancelButtonImage

        self.view.addSubview(self.cancelButton)
    }
    
    private func bindRx() {
        self.mainButton
            .rx
            .tap
            .debounce(0.4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.homeViewModel.isMainButtonShown.value = !(self?.homeViewModel.isMainButtonShown.value)!
            }).addDisposableTo(disposalBag)
        
        self.cancelButton
            .rx
            .tap
            .debounce(0.4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.homeViewModel.isMainButtonShown.value = !(self?.homeViewModel.isMainButtonShown.value)!
            }).addDisposableTo(disposalBag)
        
        self.homeViewModel.brandLogoOriginXObserver
            .subscribe(onNext: { brandLogoOriginX in
                UIView.animate(withDuration: 0.3, animations: { 
                    self.brandLogoImageView.center.x = CGFloat(brandLogoOriginX)
                })
            }).addDisposableTo(disposalBag)

        self.homeViewModel.welcomeTextOriginXObserver
            .subscribe(onNext: { welcomeTextOriginX in
                UIView.animate(withDuration: 0.3, animations: { 
                    self.welcomeTextImageView.center.x = CGFloat(welcomeTextOriginX)
                })
            }).addDisposableTo(disposalBag)
        
        self.homeViewModel.mainButtonSizeObserver
            .subscribe(onNext: { (width, height) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.mainButton.frame.size.width            = CGFloat(width)
                    self.mainButton.frame.size.height           = CGFloat(height)
                    self.mainButtonImageView.frame.size.width   = CGFloat(width)
                    self.mainButtonImageView.frame.size.height  = CGFloat(height)
                })
            }).addDisposableTo(disposalBag)
        
        self.homeViewModel.cancelButtonSizeObserver
            .subscribe(onNext: { (width, height) in
                UIView.animate(withDuration: 0.3, animations: { 
                    self.cancelButton.frame.size.width  = CGFloat(width)
                    self.cancelButton.frame.size.height = CGFloat(height)
                })
            }).addDisposableTo(disposalBag)
    }
    
}
