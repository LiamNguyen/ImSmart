//
//  AirConditionerViewController.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /03/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

class AirConditionerViewController: UIViewController, NVActivityIndicatorViewable {
    fileprivate var airConditionerViewModel: AirConditionerViewModel!
    
    @IBOutlet fileprivate weak var view_AdjustTemperature   : UIView!
    @IBOutlet fileprivate weak var btn_Mode                 : UIButton!
    @IBOutlet fileprivate weak var btn_FanSpeed             : UIButton!
    @IBOutlet fileprivate weak var btn_Swing                : UIButton!
    @IBOutlet fileprivate weak var lbl_Temperature          : UILabel!
    @IBOutlet fileprivate weak var lbl_Mode                 : UILabel!
    @IBOutlet fileprivate weak var lbl_Fanspeed             : UILabel!
    @IBOutlet fileprivate weak var lbl_Swing                : UILabel!
    
    fileprivate var topBar                  : UIView!
    fileprivate var modeSelectionView       : UIView!
    fileprivate var fanSpeedSelectionView   : UIView!
    fileprivate var swingSelectionView      : UIView!
    fileprivate var loadingView             : UIView!
    fileprivate var backIcon                : UIButton!
    fileprivate var backButton              : UIButton!
    fileprivate var coolModeButton          : UIButton!
    fileprivate var autoModeButton          : UIButton!
    fileprivate var dryModeButton           : UIButton!
    fileprivate var easyModeButton          : UIButton!
    fileprivate var lowFanSpeedButton       : UIButton!
    fileprivate var mediumFanSpeedButton    : UIButton!
    fileprivate var highFanSpeedButton      : UIButton!
    fileprivate var leftSwingButton         : UIButton!
    fileprivate var middleSwingButton       : UIButton!
    fileprivate var rightSwingButton        : UIButton!
    fileprivate var autoSwingButton         : UIButton!
    fileprivate var areaTitle               : UILabel!
    fileprivate var loadingLabel            : UILabel!
    fileprivate var activityIndicator       : NVActivityIndicatorView!
    
    fileprivate let disposalBag             = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.airConditionerViewModel = AirConditionerViewModel()
        
        guard let _ = self.airConditionerViewModel else {
            print("Air conditioner view model not set")
            return
        }
        
        customizeAppearance()
        
        bindRxObserver()
        bindRxActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view_AdjustTemperature.layer.borderWidth       = 3
        self.view_AdjustTemperature.layer.borderColor       = UIColor.white.cgColor
        self.view_AdjustTemperature.layer.cornerRadius      = 5
        
        self.btn_Mode.layer.borderWidth                     = 3
        self.btn_Mode.layer.borderColor                     = UIColor.white.cgColor
        self.btn_Mode.layer.cornerRadius                    = 5
        self.navigationController?.navigationBar.isHidden   = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        print("Air Con VC -> Dead")
    }
    
    fileprivate func bindRxObserver() {
        airConditionerViewModel.isFirstTimeGetAirConditioners.asObservable()
            .subscribe(onNext: { [weak self] isFirstTimeGetAirConditioners in
                if !isFirstTimeGetAirConditioners {
                    self?.bindRxObserverForCurrentAirConditioner()
                }
            }).addDisposableTo(disposalBag)
        
        airConditionerViewModel.loadingViewAlphaObservable
            .subscribe(onNext: { [weak self] loadingViewAlpha in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.loadingView.alpha = CGFloat(loadingViewAlpha)
                    })
                }
            }).addDisposableTo(disposalBag)
        
        airConditionerViewModel.activityIndicatorShouldSpin
            .subscribe(onNext: { [weak self] activityIndicatorShouldSpin in
                DispatchQueue.main.async {
                    activityIndicatorShouldSpin ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                }
            }).addDisposableTo(disposalBag)
    }
    
    fileprivate func bindRxObserverForCurrentAirConditioner() {
        let currentAirConditional: Variable<AirConditionerCellViewModel>
            = self.airConditionerViewModel.currentAirConditioner
        
        currentAirConditional.value.area.asObservable()
            .bindTo(areaTitle.rx.text)
            .addDisposableTo(disposalBag)
        
        currentAirConditional.value.temperature.asObservable()
            .map({ Helper.removeDecimalPartFromString(afterConvertedFromDouble: String($0)) })
            .bindTo(lbl_Temperature.rx.text)
            .addDisposableTo(disposalBag)
        
        currentAirConditional.value.mode.asObservable()
            .bindTo(lbl_Mode.rx.text)
            .addDisposableTo(disposalBag)
        
        currentAirConditional.value.fanSpeed.asObservable()
            .bindTo(lbl_Fanspeed.rx.text)
            .addDisposableTo(disposalBag)
        
        currentAirConditional.value.swing.asObservable()
            .bindTo(lbl_Swing.rx.text)
            .addDisposableTo(disposalBag)
    }
    
    fileprivate func bindRxActions() {
        self.backButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.AirConditioner.segueIdentifier.toHomeVC, sender: self)
            }).addDisposableTo(disposalBag)
        
        self.backIcon
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Constants.AirConditioner.segueIdentifier.toHomeVC, sender: self)
            }).addDisposableTo(disposalBag)
    }
    
    @IBAction func btn_TempUp_OnClick(_ sender: Any) {
    }
    
    @IBAction func btn_TempDown_OnClick(_ sender: Any) {
    }
    
    @IBAction func btn_Power_OnClick(_ sender: Any) {
    }
    
    @IBAction func btn_Timer_OnClick(_ sender: Any) {
    }
    
    @IBAction func btn_Mode_OnClick(_ sender: Any) {
        collapseSwingSelectionView()
        collapseFanSpeedSelectionView()
        
        UIView.animate(withDuration: 0.3) {
            self.modeSelectionView.frame.size.width     = 250
            self.modeSelectionView.frame.size.height    = 50
        }
        
        UIView.animate(withDuration: 0.5) {
            self.coolModeButton.frame.size.width        = 40
            self.coolModeButton.frame.size.height       = 40
            
            self.autoModeButton.frame.size.width        = 40
            self.autoModeButton.frame.size.height       = 40
            
            self.dryModeButton.frame.size.width         = 40
            self.dryModeButton.frame.size.height        = 40
            
            self.easyModeButton.frame.size.width        = 40
            self.easyModeButton.frame.size.height       = 40
        }
    }
    
    @IBAction func btn_FanSpeed_OnClick(_ sender: Any) {
        collapseModeSelectionView()
        collapseSwingSelectionView()
        
        UIView.animate(withDuration: 0.3) {
            self.fanSpeedSelectionView.frame.size.width     = 230
            self.fanSpeedSelectionView.frame.size.height    = 50
        }
        
        UIView.animate(withDuration: 0.5) { 
            self.highFanSpeedButton.frame.size.width        = 40
            self.highFanSpeedButton.frame.size.height       = 40
            
            self.mediumFanSpeedButton.frame.size.width      = 70
            self.mediumFanSpeedButton.frame.size.height     = 40
            
            self.lowFanSpeedButton.frame.size.width         = 40
            self.lowFanSpeedButton.frame.size.height        = 40
        }
    }
    
    @IBAction func btn_Swing_OnClick(_ sender: Any) {
        collapseModeSelectionView()
        collapseFanSpeedSelectionView()
        
        UIView.animate(withDuration: 0.3) {
            self.swingSelectionView.frame.size.width     = 272
            self.swingSelectionView.frame.size.height    = 50
        }
        
        UIView.animate(withDuration: 0.5) {
            self.leftSwingButton.frame.size.width        = 50
            self.leftSwingButton.frame.size.height       = 40
            
            self.middleSwingButton.frame.size.width      = 50
            self.middleSwingButton.frame.size.height     = 40
            
            self.rightSwingButton.frame.size.width       = 60
            self.rightSwingButton.frame.size.height      = 40
            
            self.autoSwingButton.frame.size.width        = 60
            self.autoSwingButton.frame.size.height       = 40
        }
    }
    
    fileprivate func customizeAppearance() {
        drawTopBar()
        drawModeSelectionView()
        drawFanSpeedSelectionView()
        drawSwingSelectionView()
        drawLoadingView()
    }
    
//** Mark: DRAWING TOP BAR
    
    fileprivate func drawTopBar() {
        self.topBar                     = UIView()
        
        topBar.backgroundColor          = Theme.customBackgroundColor
        topBar.alpha                    = 0.7
        
        self.view.addSubview(topBar)
        
        topBar.snp.makeConstraints { maker in
            maker.height.equalTo(80)
            maker.left.equalToSuperview().offset(0)
            maker.top.equalToSuperview().offset(0)
            maker.right.equalToSuperview().offset(0)
        }
        
        drawAreaTitle()
        drawBackIcon()
        drawBackButton()
        drawBackButtonStackView()
    }
    
//** Mark: DRAWING BACK BUTTON STACKVIEW
    
    fileprivate func drawBackButtonStackView() {
        let backButtonStackView         = UIStackView()
        
        backButtonStackView.axis        = .horizontal
        backButtonStackView.spacing     = 0
        backButtonStackView.alignment   = .center
        
        backButtonStackView.addArrangedSubview(self.backIcon)
        backButtonStackView.addArrangedSubview(self.backButton)
        
        self.view.addSubview(backButtonStackView)
        
        backButtonStackView.snp.makeConstraints { maker in
            maker.left.equalTo(self.topBar.snp.left).offset(5)
            maker.bottom.equalTo(self.topBar.snp.bottom).offset(-10)
        }
    }
    
//** Mark: DRAWING BACK ICON

    fileprivate func drawBackIcon() {
        let backIconImage       = UIImage(named: Constants.AirConditioner.View.backIcon)?.cgImage
        
        self.backIcon           = UIButton()
        backIcon.layer.contents = backIconImage
        
        backIcon.snp.makeConstraints { maker in
            maker.width.equalTo(24)
            maker.height.equalTo(27)
        }
    }
    
//** Mark: DRAWING BACK BUTTON

    fileprivate func drawBackButton() {
        self.backButton = UIButton()
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.setTitleColor(Theme.customItemColor, for: .normal)
        backButton.setTitle(Constants.AirConditioner.BarItem.back, for: .normal)
        
        backButton.snp.makeConstraints { maker in
            maker.width.equalTo(50)
            maker.height.equalTo(30)
        }
    }
    
//** Mark: DRAWING AREA TITLE
    
    fileprivate func drawAreaTitle() {
        self.areaTitle          = UILabel()
        
        areaTitle.font          = UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold)
        areaTitle.textAlignment = .center
        areaTitle.text          = Constants.AirConditioner.BarItem.areaLabel
        areaTitle.textColor     = Theme.customItemColor
        
        self.topBar.addSubview(areaTitle)
        
        areaTitle.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(self.topBar.snp.bottom).offset(-15)
        }
    }
    
//** Mark: DRAWING MODE SELECTION VIEW
    
    fileprivate func drawModeSelectionView() {
        self.modeSelectionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.modeSelectionView.center = CGPoint(
            x: Int(Constants.Window.screenWidth / 2 - 97),
            y: Int(Constants.Window.screenHeight - 260)
        )
        
        modeSelectionView.backgroundColor       = Theme.customBackgroundColor
        modeSelectionView.layer.borderWidth     = 3
        modeSelectionView.layer.borderColor     = UIColor.white.cgColor
        modeSelectionView.layer.cornerRadius    = 5
        UIFunctionality.applyShadow(modeSelectionView, withColor: UIColor.black)
        
        self.view.addSubview(modeSelectionView)
        
        drawCoolMode()
        drawAutoMode()
        drawDryMode()
        drawEasyMode()
    }

//** Mark: DRAWING MODE OPTIONS: Cool

    fileprivate func drawCoolMode() {
        
        let coolModeImage               = UIImage(named: Constants.AirConditioner.View.snowFlake)?.cgImage
        
        self.coolModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.coolModeButton.center      = CGPoint(x: 15, y: 5)
        coolModeButton.layer.contents   = coolModeImage
        
        self.modeSelectionView.addSubview(coolModeButton)
    }
    
//** Mark: DRAWING MODE OPTIONS: Cool
    
    fileprivate func drawAutoMode() {
        
        let autoModeImage               = UIImage(named: Constants.AirConditioner.View.standFanIcon)?.cgImage
        
        self.autoModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.autoModeButton.center      = CGPoint(x: 75, y: 5)
        autoModeButton.layer.contents   = autoModeImage
        
        self.modeSelectionView.addSubview(autoModeButton)
    }
    
//** Mark: DRAWING MODE OPTIONS: Cool
    
    fileprivate func drawDryMode() {
        
        let dryModeImage               = UIImage(named: Constants.AirConditioner.View.sunIcon)?.cgImage
        
        self.dryModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.dryModeButton.center      = CGPoint(x: 135, y: 5)
        dryModeButton.layer.contents   = dryModeImage
        
        self.modeSelectionView.addSubview(dryModeButton)
    }
    
//** Mark: DRAWING MODE OPTIONS: Cool
    
    fileprivate func drawEasyMode() {
        
        let easyModeImage               = UIImage(named: Constants.AirConditioner.View.tearDropIcon)?.cgImage
        
        self.easyModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.easyModeButton.center      = CGPoint(x: 195, y: 5)
        easyModeButton.layer.contents   = easyModeImage
        
        self.modeSelectionView.addSubview(easyModeButton)
    }
    
//** Mark: COLLAPSE MODE SELECTION VIEW
    
    fileprivate func collapseModeSelectionView() {
        UIView.animate(withDuration: 0.5) {
            self.modeSelectionView.frame.size.width     = 0
            self.modeSelectionView.frame.size.height    = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.coolModeButton.frame.size.width        = 0
            self.coolModeButton.frame.size.height       = 0
            
            self.autoModeButton.frame.size.width        = 0
            self.autoModeButton.frame.size.height       = 0
            
            self.dryModeButton.frame.size.width         = 0
            self.dryModeButton.frame.size.height        = 0
            
            self.easyModeButton.frame.size.width        = 0
            self.easyModeButton.frame.size.height       = 0
        }
    }
    
//** Mark: DRAWING FAN SPEED SELECTION VIEW
    
    fileprivate func drawFanSpeedSelectionView() {
        self.fanSpeedSelectionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.fanSpeedSelectionView.center = CGPoint(
            x: Int(Constants.Window.screenWidth / 2 - 68),
            y: Int(Constants.Window.screenHeight - 180)
        )
        
        fanSpeedSelectionView.backgroundColor       = Theme.customBackgroundColor
        fanSpeedSelectionView.layer.borderWidth     = 3
        fanSpeedSelectionView.layer.borderColor     = UIColor.white.cgColor
        fanSpeedSelectionView.layer.cornerRadius    = 5
        UIFunctionality.applyShadow(fanSpeedSelectionView, withColor: UIColor.black)
        
        self.view.addSubview(fanSpeedSelectionView)
        
        drawHighFanSpeedButton()
        drawMediumFanSpeedButton()
        drawLowFanSpeedButton()
    }
    
//** Mark: DRAWING HIGH FAN SPEED BUTTON

    fileprivate func drawHighFanSpeedButton() {
        self.highFanSpeedButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.highFanSpeedButton.center      = CGPoint(x: 15, y: 5)
        
        highFanSpeedButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        highFanSpeedButton.setTitle(Constants.AirConditioner.FanSpeed.high, for: .normal)
        highFanSpeedButton.setTitleColor(UIColor.white, for: .normal)
        
        self.fanSpeedSelectionView.addSubview(highFanSpeedButton)
    }
    
//** Mark: DRAWING MEDIUM FAN SPEED BUTTON
    
    fileprivate func drawMediumFanSpeedButton() {
        self.mediumFanSpeedButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.mediumFanSpeedButton.center      = CGPoint(x: 75, y: 5)
        
        mediumFanSpeedButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        mediumFanSpeedButton.setTitle(Constants.AirConditioner.FanSpeed.medium, for: .normal)
        mediumFanSpeedButton.setTitleColor(UIColor.white, for: .normal)
        
        self.fanSpeedSelectionView.addSubview(mediumFanSpeedButton)
    }
    
//** Mark: DRAWING LOW FAN SPEED BUTTON
    
    fileprivate func drawLowFanSpeedButton() {
        self.lowFanSpeedButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.lowFanSpeedButton.center      = CGPoint(x: 170, y: 5)
        
        lowFanSpeedButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        lowFanSpeedButton.setTitle(Constants.AirConditioner.FanSpeed.low, for: .normal)
        lowFanSpeedButton.setTitleColor(UIColor.white, for: .normal)
        
        self.fanSpeedSelectionView.addSubview(lowFanSpeedButton)
    }
    
//** Mark: COLLAPSE FAN SPEED SELECTION VIEW

    func collapseFanSpeedSelectionView() {
        UIView.animate(withDuration: 0.5) {
            self.fanSpeedSelectionView.frame.size.width     = 0
            self.fanSpeedSelectionView.frame.size.height    = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.highFanSpeedButton.frame.size.width        = 0
            self.highFanSpeedButton.frame.size.height       = 0
            
            self.mediumFanSpeedButton.frame.size.width      = 0
            self.mediumFanSpeedButton.frame.size.height     = 0
            
            self.lowFanSpeedButton.frame.size.width         = 0
            self.lowFanSpeedButton.frame.size.height        = 0
        }
    }
    
//** Mark: DRAWING SWING SELECTION VIEW
    
    fileprivate func drawSwingSelectionView() {
        self.swingSelectionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.swingSelectionView.center = CGPoint(
            x: Int(Constants.Window.screenWidth / 2 - 133),
            y: Int(Constants.Window.screenHeight - 180)
        )
        
        swingSelectionView.backgroundColor       = Theme.customBackgroundColor
        swingSelectionView.layer.borderWidth     = 3
        swingSelectionView.layer.borderColor     = UIColor.white.cgColor
        swingSelectionView.layer.cornerRadius    = 5
        UIFunctionality.applyShadow(swingSelectionView, withColor: UIColor.black)
        
        self.view.addSubview(swingSelectionView)
        
        drawLeftSwingButton()
        drawMiddleSwingButton()
        drawRightSwingButton()
        drawAutoSwingButton()
    }
    
//** Mark: DRAWING LEFT SWING BUTTON
    
    fileprivate func drawLeftSwingButton() {
        self.leftSwingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.leftSwingButton.center      = CGPoint(x: 10, y: 5)
        
        leftSwingButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        leftSwingButton.setTitle(Constants.AirConditioner.Swing.left, for: .normal)
        leftSwingButton.setTitleColor(UIColor.white, for: .normal)
        
        self.swingSelectionView.addSubview(leftSwingButton)
    }
    
//** Mark: DRAWING MIDDLE SWING BUTTON
    
    fileprivate func drawMiddleSwingButton() {
        self.middleSwingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.middleSwingButton.center      = CGPoint(x: 70, y: 5)
        middleSwingButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        middleSwingButton.setTitle(Constants.AirConditioner.Swing.middle, for: .normal)
        middleSwingButton.setTitleColor(UIColor.white, for: .normal)
        
        self.swingSelectionView.addSubview(middleSwingButton)
    }
    
//** Mark: DRAWING RIGHT SWING BUTTON
    
    fileprivate func drawRightSwingButton() {
        self.rightSwingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.rightSwingButton.center      = CGPoint(x: 133, y: 5)
        rightSwingButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        rightSwingButton.setTitle(Constants.AirConditioner.Swing.right, for: .normal)
        rightSwingButton.setTitleColor(UIColor.white, for: .normal)
        
        self.swingSelectionView.addSubview(rightSwingButton)
    }
    
//** Mark: DRAWING AUTO SWING BUTTON
    
    fileprivate func drawAutoSwingButton() {
        self.autoSwingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.autoSwingButton.center      = CGPoint(x: 205, y: 5)
        autoSwingButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        autoSwingButton.setTitle(Constants.AirConditioner.Swing.auto, for: .normal)
        autoSwingButton.setTitleColor(UIColor.white, for: .normal)
        
        self.swingSelectionView.addSubview(autoSwingButton)
    }
    
//** Mark: COLLAPSE SWING SELECTION VIEW
    
    fileprivate func collapseSwingSelectionView() {
        UIView.animate(withDuration: 0.5) {
            self.swingSelectionView.frame.size.width     = 0
            self.swingSelectionView.frame.size.height    = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.leftSwingButton.frame.size.width        = 0
            self.leftSwingButton.frame.size.height       = 0
            
            self.middleSwingButton.frame.size.width      = 0
            self.middleSwingButton.frame.size.height     = 0
            
            self.rightSwingButton.frame.size.width       = 0
            self.rightSwingButton.frame.size.height      = 0
            
            self.autoSwingButton.frame.size.width        = 0
            self.autoSwingButton.frame.size.height       = 0
        }
    }
    
//** Mark: DRAWING LOADING VIEW
    
    fileprivate func drawLoadingView() {
        self.loadingView = UIView()
        
        loadingView.backgroundColor = .black
        
        self.view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.top).offset(0)
            maker.right.equalTo(self.view.snp.right).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            maker.left.equalTo(self.view.snp.left).offset(0)
        }
        
        drawActivityIndicatorView()
        drawLoadingLabel()
    }
    
//** Mark: DRAW ACTIVITY INDICATOR
    
    fileprivate func drawActivityIndicatorView() {
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        self.activityIndicator = NVActivityIndicatorView(
            frame: frame,
            type: .ballRotateChase,
            color: .white,
            padding: 0
        )
        
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
//** Mark: DRAW LOADING LABEL
    
    fileprivate func drawLoadingLabel() {
        self.loadingLabel = UILabel()
        
        loadingLabel.font          = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBold)
        loadingLabel.textAlignment = .center
        loadingLabel.text          = Constants.AirConditioner.View.loadingLabel
        loadingLabel.textColor     = Theme.customItemColor
        
        self.loadingView.addSubview(loadingLabel)

        loadingLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.activityIndicator.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
        }
    }
    
//** Mark: HANDLE EVENT WHEN UIVIEW IS TOUCHED
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        collapseModeSelectionView()
        collapseFanSpeedSelectionView()
        collapseSwingSelectionView()
    }
}
