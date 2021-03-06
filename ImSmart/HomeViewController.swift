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
import SnapKit
import NVActivityIndicatorView

class HomeViewController: UIViewController, NVActivityIndicatorViewable {
    
    var homeViewModel               : HomeViewModel!
    
    fileprivate var mainButton          : UIButton!
    fileprivate var cancelButton        : UIButton!
    fileprivate var lightsButton        : UIButton!
    fileprivate var addLightButton      : UIButton!
    fileprivate var airConditionerButton: UIButton!
    fileprivate var fridgeButton        : UIButton!
    fileprivate var shoppingCartButton  : UIButton!
    fileprivate var homeButton          : UIButton!
    fileprivate var mainButtonImageView : UIImageView!
    fileprivate var brandLogoImageView  : UIImageView!
    fileprivate var welcomeTextImageView: UIImageView!
    fileprivate var menuView            : UIView!
    fileprivate var topBar              : UIView!
    fileprivate var devicesStackView    : UIStackView!
    fileprivate var devicesScrollView   : UIScrollView!
    fileprivate var activityIndicator   : NVActivityIndicatorView!
    fileprivate var connectionsLabel    : UILabel!
    
    fileprivate let disposalBag         = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeAppearance()
        
        guard let _ = self.homeViewModel else {
            print("Home view model not set")
            return
        }
        
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
        setAppearanceAsDefault()
    }
    
    fileprivate func bindRxObserver() {
//** Mark: BRAND LOGO
        
        self.homeViewModel.brandLogoOriginXObserver
            .subscribe(onNext: { [weak self] brandLogoOriginX in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.brandLogoImageView.center.x = CGFloat(brandLogoOriginX)
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: WELCOME TEXT
        
        self.homeViewModel.welcomeTextOriginXObserver
            .subscribe(onNext: { [weak self] welcomeTextOriginX in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.welcomeTextImageView.center.x = CGFloat(welcomeTextOriginX)
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: MAIN BUTTON
        
        self.homeViewModel.mainButtonSizeObserver
            .subscribe(onNext: { [weak self] (width, height) in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.mainButton.frame.size.width            = CGFloat(width)
                        self?.mainButton.frame.size.height           = CGFloat(height)
                        self?.mainButtonImageView.frame.size.width   = CGFloat(width)
                        self?.mainButtonImageView.frame.size.height  = CGFloat(height)
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: CANCEL BUTTON

        self.homeViewModel.cancelButtonSizeObserver
            .subscribe(onNext: { [weak self] (width, height) in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.cancelButton.frame.size.width  = CGFloat(width)
                        self?.cancelButton.frame.size.height = CGFloat(height)
                    })
                }
            }).addDisposableTo(disposalBag)

//** Mark: LIGHT BUTTON

        self.homeViewModel.lightsButtonPositionObserver
            .subscribe(onNext: { [weak self] lightsButtonCoordinate in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.lightsButton.center = CGPoint(
                            x: CGFloat(lightsButtonCoordinate.x),
                            y: CGFloat(lightsButtonCoordinate.y)
                        )
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: ADD LIGHT BUTTON
        
        self.homeViewModel.addLightButtonPositionObserver
            .subscribe(onNext: { [weak self] addLightButtonPositionObserver in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: { 
                        self?.addLightButton.center = CGPoint(
                            x: CGFloat(addLightButtonPositionObserver.x),
                            y: CGFloat(addLightButtonPositionObserver.y)
                        )
                    })
                }
            }).addDisposableTo(disposalBag)
        
        self.homeViewModel.isAddLightButtonShown.asObservable()
            .subscribe(onNext: { [weak self] isAddLightButtonShown in
                DispatchQueue.main.async {
                    self?.addLightButton.isHidden = !isAddLightButtonShown
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: AIR CONDITIONER BUTTON

        self.homeViewModel.airConditionerPositionObserver
            .subscribe(onNext: { [weak self] airConditionerButtonCoordinate in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.airConditionerButton.center = CGPoint(
                            x: CGFloat(airConditionerButtonCoordinate.x),
                            y: CGFloat(airConditionerButtonCoordinate.y)
                        )
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: SHOPPING CART BUTTON

        self.homeViewModel.shoppingCartButtonPositionObserver
            .subscribe(onNext: { [weak self] shoppingCartButtonCoordinate in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.shoppingCartButton.center = CGPoint(
                            x: CGFloat(shoppingCartButtonCoordinate.x),
                            y: CGFloat(shoppingCartButtonCoordinate.y)
                        )
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: FRIDGE BUTTON

        self.homeViewModel.fridgeButtonPositionObserver
            .subscribe(onNext: { [weak self] fridgeButtonCoordinate in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.fridgeButton.center = CGPoint(
                            x: CGFloat(fridgeButtonCoordinate.x),
                            y: CGFloat(fridgeButtonCoordinate.y)
                        )
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: CONNECTIONS LABEL
        
        self.homeViewModel.connectionsLabelObserver
            .subscribe(onNext: { [weak self] connectionsLabel in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.connectionsLabel.text = connectionsLabel
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: MENU VIEW 
        
        self.homeViewModel.menuViewOriginXObserver
            .map({ CGFloat($0) })
            .subscribe(onNext: { [weak self] menuViewOriginX in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: { 
                        self?.menuView.center.x = menuViewOriginX
                    })
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: ACTIVITY INDICATOR
        
        self.homeViewModel.activityIndicatorShouldSpin
            .subscribe(onNext: { [weak self] shouldSpin in
                DispatchQueue.main.async {
                    shouldSpin ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                }
            }).addDisposableTo(disposalBag)
    }
    
    fileprivate func bindRxActions() {
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
                self?.homeViewModel.isMainButtonShown.value     = !(self?.homeViewModel.isMainButtonShown.value)!
                self?.homeViewModel.isAddLightButtonShown.value = false
            }).addDisposableTo(disposalBag)
        
//** Mark: LIGHT BUTTON

        self.lightsButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                if self!.homeViewModel.isAddLightButtonShown.value {
                    self?.performSegue(withIdentifier: Constants.Home.SegueIdentifier.toLightVC, sender: self)
                } else {
                    self?.homeViewModel.isAddLightButtonShown.value = true
                }
            }).addDisposableTo(disposalBag)
        
//** Mark: ADD LIGHT BUTTON

        self.addLightButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.Home.SegueIdentifier.toAddLightVc, sender: self)
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
        
//** Mark: HOME BUTTON
        
        self.homeButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.homeViewModel.menuViewShouldShow.value = !(self?.homeViewModel.menuViewShouldShow.value)!
            }).addDisposableTo(disposalBag)
    }
    
    fileprivate func customizeAppearance() {
        self.view.layer.contents = UIImage(named: Constants.Home.View.homeBackground)?.cgImage
        
        drawBrandLogo()
        drawWelcomeText()
        drawCancelButton()
        drawLightsButton()
        drawAddLightButton()
        drawAirConditionerButton()
        drawShoppingCartButton()
        drawFridgeButton()
        drawMainButton()
        drawHomeButton()
        drawMenuView()
    }
    
//** Mark: DRAWING BRAND LOGO

    fileprivate func drawBrandLogo() {
        let brandLogoImage                   = UIImage(named: Constants.Home.View.logo)
        
        self.brandLogoImageView              = UIImageView(image: brandLogoImage)
        self.brandLogoImageView.frame        = CGRect(x: 0, y: 0, width: 250, height: 100)
        self.brandLogoImageView.center       = CGPoint(x: UIScreen.main.bounds.width / 2, y: 120)
        self.brandLogoImageView.contentMode  = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.brandLogoImageView)
    }
    
//** Mark: DRAWING WELCOME TEXT

    fileprivate func drawWelcomeText() {
        let welcomeTextImage                   = UIImage(named: Constants.Home.View.welcomeText)
        
        self.welcomeTextImageView              = UIImageView(image: welcomeTextImage)
        self.welcomeTextImageView.frame        = CGRect(x: 0, y: 0, width: 320, height: 100)
        self.welcomeTextImageView.center       = CGPoint(x: UIScreen.main.bounds.width + 400, y: 120)
        self.welcomeTextImageView.contentMode  = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.welcomeTextImageView)
    }
    
//** Mark: DRAWING MAIN BUTTON

    fileprivate func drawMainButton() {
        self.mainButton                             = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        self.mainButton.frame                       = self.mainButton.bounds
        self.mainButton.center                      = CGPoint(x: UIScreen.main.bounds.width / 2, y: Constants.Home.View.mainButtonPosition)
        UIFunctionality.applyShadow(self.mainButton, withColor: UIColor.red)
        
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
    
    fileprivate func drawCancelButton() {
        let cancelButtonImage               = UIImage(named: Constants.Home.View.cancelButton)?.cgImage
        
        self.cancelButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.cancelButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: Constants.Home.View.mainButtonPosition)
        self.cancelButton.layer.contents    = cancelButtonImage

        self.view.addSubview(self.cancelButton)
    }
    
//** Mark: DRAWING LIGHT BUTTON
    
    fileprivate func drawLightsButton() {
        let lightsButtonImage               = UIImage(named: Constants.Home.View.lightsButton)?.cgImage
        
        self.lightsButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.lightsButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: Constants.Home.View.mainButtonPosition)
        self.lightsButton.layer.contents    = lightsButtonImage
        
        self.view.addSubview(self.lightsButton)
    }
    
//** Mark: DRAWING ADD LIGHT BUTTON
    
    fileprivate func drawAddLightButton() {
        let addLightButtonImage             = UIImage(named: Constants.Home.View.addButton)?.cgImage
        
        self.addLightButton                 = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.addLightButton.center          = CGPoint(x: UIScreen.main.bounds.width / 2 - 65, y: Constants.Home.View.mainButtonPosition - 65)
        self.addLightButton.layer.contents  = addLightButtonImage
        
        self.view.addSubview(self.addLightButton)
    }
    
//** Mark: DRAWING ARI CONDITIONER BUTTON
    
    fileprivate func drawAirConditionerButton() {
        let airConditionerButtonImage               = UIImage(named: Constants.Home.View.airConditionerButton)?.cgImage
        
        self.airConditionerButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.airConditionerButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: Constants.Home.View.mainButtonPosition)
        self.airConditionerButton.layer.contents    = airConditionerButtonImage
        
        self.view.addSubview(self.airConditionerButton)
    }
    
//** Mark: DRAWING SHOPPING CART BUTTON
    
    fileprivate func drawShoppingCartButton() {
        let shoppingCartButtonImage               = UIImage(named: Constants.Home.View.shoppingCartButton)?.cgImage
        
        self.shoppingCartButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.shoppingCartButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: Constants.Home.View.mainButtonPosition)
        self.shoppingCartButton.layer.contents    = shoppingCartButtonImage
        
        self.view.addSubview(self.shoppingCartButton)
    }
    
//** Mark: DRAWING FRIDGE BUTTON
    
    fileprivate func drawFridgeButton() {
        let fridgeButtonImage               = UIImage(named: Constants.Home.View.fridgeButton)?.cgImage
        
        self.fridgeButton                   = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.fridgeButton.center            = CGPoint(x: UIScreen.main.bounds.width / 2, y: Constants.Home.View.mainButtonPosition)
        self.fridgeButton.layer.contents    = fridgeButtonImage
        
        self.view.addSubview(self.fridgeButton)
    }
    
//** Mark: DRAWING HOME BUTTON

    fileprivate func drawHomeButton() {
        let size                          = Constants.Home.View.homeButtonSize
        
        let homeButtonImage               = UIImage(named: Constants.Home.View.homeButton)?.cgImage
        
        self.homeButton                   = UIButton()
        self.homeButton.layer.contents    = homeButtonImage
        
        self.view.addSubview(self.homeButton)
        
        self.homeButton.snp.makeConstraints { maker in
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.height)
            maker.top.equalTo(self.view.snp.top).offset(40)
            maker.right.equalTo(self.view.snp.right).offset(-20)
        }
    }
    
//** Mark: DRAWING MENU VIEW
    
    fileprivate func drawMenuView() {
        self.menuView                 = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: self.view.frame.height))
        
        self.menuView.center          = CGPoint(x: self.view.frame.width + 135, y: self.view.frame.height / 2)
        self.menuView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.menuView)
        
        drawTopBar()
        drawTitle()
        drawConnectionsLabel()
        drawActivityIndicatorView()
        drawMenuViewFooter()
    }
    
//** Mark: DRAWING TOP BAR OF MENU
    
    fileprivate func drawTopBar() {
        self.topBar = UIView()
        
        topBar.backgroundColor  = UIColor.black
        topBar.alpha            = 0.7
        
        self.menuView.addSubview(topBar)
        
        topBar.snp.makeConstraints { maker in
            maker.height.equalTo(63)
            maker.left.equalToSuperview().offset(0)
            maker.top.equalToSuperview().offset(0)
            maker.right.equalToSuperview().offset(0)
        }
    }
    
//** Mark: DRAWING TITLE
    
    fileprivate func drawTitle() {
        let title           = UILabel()
        
        title.font          = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBold)
        title.textAlignment = .center
        title.text          = Constants.Home.Menu.title
        title.textColor     = UIColor.red
        
        self.topBar.addSubview(title)
        
        title.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
//** Mark: DRAWING CONNECTIONS LABEL
    
    fileprivate func drawConnectionsLabel() {
        self.connectionsLabel = UILabel()
        
        connectionsLabel.text = Constants.Home.Menu.waitingConnection
        
        self.menuView.addSubview(connectionsLabel)
        
        connectionsLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.topBar.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
        }
    }
    
//** Mark: DRAWING CONNECTED DEVICES SCROLL VIEW
    
    fileprivate func drawDevicesView(_ connectedDevices: [String]) {
        if let stackView = self.devicesStackView, let scrollView = self.devicesScrollView {
            stackView.removeFromSuperview()
            scrollView.removeFromSuperview()
        }
        
        self.devicesStackView       = UIStackView()
        self.devicesScrollView      = UIScrollView()
        
        devicesStackView.axis       = .vertical
        devicesStackView.spacing    = 5
        devicesStackView.alignment  = .center
        
        for device in connectedDevices {
            let deviceLabel = drawDeviceLabel(device)
            devicesStackView.addArrangedSubview(deviceLabel)
        }
        
        devicesScrollView.addSubview(devicesStackView)
        self.menuView.addSubview(devicesScrollView)
        
        devicesStackView.snp.makeConstraints { maker in
            maker.top.equalTo(devicesScrollView.snp.top).offset(0)
            maker.right.equalTo(devicesScrollView.snp.right).offset(0)
            maker.bottom.equalTo(devicesScrollView.snp.bottom).offset(0)
            maker.left.equalTo(devicesScrollView.snp.left).offset(0)
        }
        
        devicesScrollView.snp.makeConstraints { maker in
            maker.top.equalTo(self.connectionsLabel.snp.top).offset(40)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(devicesStackView.snp.width).offset(5)
            maker.height.equalTo(80)
        }
    }
    
//** Mark: DRAWING DEVICE LABEL
    
    fileprivate func drawDeviceLabel(_ deviceName: String) -> UILabel {
        let deviceLabel = UILabel()
        
        deviceLabel.text = deviceName
        deviceLabel.font = UIFont.systemFont(ofSize: 13)
        
        return deviceLabel
    }
    
//** Mark: DRAWING ACTIVITY INDICATOR VIEW
    
    fileprivate func drawActivityIndicatorView() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator = NVActivityIndicatorView(
            frame: frame,
            type: .ballScaleRippleMultiple,
            color: .red, padding: 0
        )
        
        self.menuView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { maker in
            maker.top.equalTo(self.connectionsLabel.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
        }
    }
    
//** Mark: DRAWING FOOTER OF MENU
    
    fileprivate func drawMenuViewFooter() {
        let tcButton                = drawTermsAndCondiTionsButton()
        let privacyStatementButton  = drawPrivacyStatementButton()
        let versionLabel            = drawVersionLabel()
        let buttonsStackView        = UIStackView()
        let footerStackView         = UIStackView()
        
        buttonsStackView.axis       = .horizontal
        buttonsStackView.spacing    = 15
        buttonsStackView.alignment  = .center
        buttonsStackView.addArrangedSubview(tcButton)
        buttonsStackView.addArrangedSubview(privacyStatementButton)
        
        footerStackView.axis        = .vertical
        footerStackView.spacing     = 4
        footerStackView.alignment   = .center
        footerStackView.addArrangedSubview(buttonsStackView)
        footerStackView.addArrangedSubview(versionLabel)
        
        self.menuView.addSubview(footerStackView)
        
        footerStackView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(self.menuView.snp.bottom).offset(-10)
        }
    }
    
//** Mark: DRAWING TERMS AND CONDITIONS BUTTON
    
    fileprivate func drawTermsAndCondiTionsButton() -> UIButton {
        let tcButton                = UIButton()
        
        tcButton.titleLabel?.font   = UIFont.systemFont(ofSize: 12)
        tcButton.setTitle(Constants.Home.Menu.tcButton, for: .normal)
        tcButton.setTitleColor(UIColor.darkGray, for: .normal)

        return tcButton
    }
    
//** Mark: DRAWING PRIVACY STATEMENT BUTTON
    
    fileprivate func drawPrivacyStatementButton() -> UIButton {
        let privacyStatementButton              = UIButton()
        
        privacyStatementButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        privacyStatementButton.setTitle(Constants.Home.Menu.privacyStatement, for: .normal)
        privacyStatementButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        return privacyStatementButton
    }
    
//** Mark: DRAWING VERSION LABEL
    
    fileprivate func drawVersionLabel() -> UILabel {
        let versionLabel        = UILabel()
        
        versionLabel.text       = Constants.Home.Menu.version
        versionLabel.textColor  = UIColor.gray
        versionLabel.font       = UIFont.systemFont(ofSize: 11)
        
        return versionLabel
    }
    
//** Mark: HANDLE EVENT WHEN UIVIEW IS TOUCHED

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = self.homeViewModel else {
            print("Home view model not set")
            return
        }
        
        setAppearanceAsDefault()
    }
    
    fileprivate func setAppearanceAsDefault() {
        self.homeViewModel.menuViewShouldShow.value     = false
        self.homeViewModel.isMainButtonShown.value      = true
        self.homeViewModel.isAddLightButtonShown.value  = false
    }
    
    @IBAction func unwindToHomeViewController(_ segue: UIStoryboardSegue) {}
}
