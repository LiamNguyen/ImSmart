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

class AirConditionerViewController: UIViewController {
    @IBOutlet private weak var view_AdjustTemperature   : UIView!
    @IBOutlet private weak var btn_Mode                 : UIButton!
    @IBOutlet private weak var btn_FanSpeed             : UIButton!
    @IBOutlet private weak var btn_Swing                : UIButton!
    
    private var topBar                  : UIView!
    private var backIcon                : UIButton!
    private var backButton              : UIButton!
    private var modeSelectionView       : UIView!
    private var fanSpeedSelectionView   : UIView!
    private var swingSelectionView      : UIView!
    private var coolModeButton          : UIButton!
    private var autoModeButton          : UIButton!
    private var dryModeButton           : UIButton!
    private var easyModeButton          : UIButton!
    
    private let disposalBag             = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func bindRxObserver() {
        
    }
    
    private func bindRxActions() {
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
    }
    
    @IBAction func btn_Swing_OnClick(_ sender: Any) {
    }
    
    private func customizeAppearance() {
        drawTopBar()
        drawModeSelectionView()
    }
    
//** Mark: DRAWING TOP BAR
    
    private func drawTopBar() {
        self.topBar = UIView()
        
        topBar.backgroundColor  = Theme.customBackgroundColor
        topBar.alpha            = 0.7
        
        self.view.addSubview(topBar)
        
        topBar.snp.makeConstraints { maker in
            maker.height.equalTo(80)
            maker.left.equalToSuperview().offset(0)
            maker.top.equalToSuperview().offset(0)
            maker.right.equalToSuperview().offset(0)
        }
        
        drawBackIcon()
        drawBackButton()
        drawAreaTitle()
    }
    
//** Mark: DRAWING BACK ICON

    private func drawBackIcon() {
        let backIconImage       = UIImage(named: Constants.AirConditioner.View.backIcon)?.cgImage
        
        self.backIcon           = UIButton()
        backIcon.layer.contents = backIconImage
        
        self.topBar.addSubview(backIcon)
        
        backIcon.snp.makeConstraints { maker in
            maker.width.equalTo(24)
            maker.height.equalTo(27)
            maker.left.equalTo(self.topBar.snp.left).offset(5)
            maker.centerY.equalToSuperview()
        }
    }
    
//** Mark: DRAWING BACK BUTTON

    private func drawBackButton() {
        self.backButton = UIButton()
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.setTitleColor(Theme.customItemColor, for: .normal)
        backButton.setTitle(Constants.AirConditioner.BarItem.back, for: .normal)
        
        self.topBar.addSubview(backButton)
        
        backButton.snp.makeConstraints { maker in
            maker.width.equalTo(50)
            maker.height.equalTo(30)
            maker.left.equalTo(backIcon.snp.right).offset(0)
            maker.centerY.equalToSuperview()
        }
    }
    
//** Mark: DRAWING AREA TITLE
    
    private func drawAreaTitle() {
        let title           = UILabel()
        
        title.font          = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBold)
        title.textAlignment = .center
        title.text          = Constants.AirConditioner.BarItem.areaLabel
        title.textColor     = Theme.customItemColor
        
        self.topBar.addSubview(title)
        
        title.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
//** Mark: DRAWING MODE SELECTION VIEW
    
    private func drawModeSelectionView() {
        self.modeSelectionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.modeSelectionView.center = CGPoint(
            x: Int(Constants.Window.screenWidth / 2 - 97),
            y: Int(Constants.Window.screenHeight - 260)
        )
        
        modeSelectionView.backgroundColor       = Theme.customBackgroundColor
        modeSelectionView.layer.borderWidth     = 3
        modeSelectionView.layer.borderColor     = UIColor.white.cgColor
        modeSelectionView.layer.cornerRadius    = 5
        UIFunctionality.applyShadow(toView: modeSelectionView, withColor: UIColor.black)
        
        self.view.addSubview(modeSelectionView)
        
        drawCoolMode()
        drawAutoMode()
        drawDryMode()
        drawEasyMode()
    }

//** Mark: DRAWING MODE OPTIONS: Cool

    private func drawCoolMode() {
        
        let coolModeImage               = UIImage(named: Constants.AirConditioner.View.snowFlake)?.cgImage
        
        self.coolModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.coolModeButton.center      = CGPoint(x: 10, y: 5)
        coolModeButton.layer.contents   = coolModeImage
        
        self.modeSelectionView.addSubview(coolModeButton)
    }
    
//** Mark: DRAWING MODE OPTIONS: Cool
    
    private func drawAutoMode() {
        
        let autoModeImage               = UIImage(named: Constants.AirConditioner.View.standFanIcon)?.cgImage
        
        self.autoModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.autoModeButton.center      = CGPoint(x: 70, y: 5)
        autoModeButton.layer.contents   = autoModeImage
        
        self.modeSelectionView.addSubview(autoModeButton)
    }
    
//** Mark: DRAWING MODE OPTIONS: Cool
    
    private func drawDryMode() {
        
        let dryModeImage               = UIImage(named: Constants.AirConditioner.View.sunIcon)?.cgImage
        
        self.dryModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.dryModeButton.center      = CGPoint(x: 130, y: 5)
        dryModeButton.layer.contents   = dryModeImage
        
        self.modeSelectionView.addSubview(dryModeButton)
    }
    
//** Mark: DRAWING MODE OPTIONS: Cool
    
    private func drawEasyMode() {
        
        let easyModeImage               = UIImage(named: Constants.AirConditioner.View.tearDropIcon)?.cgImage
        
        self.easyModeButton             = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.easyModeButton.center      = CGPoint(x: 190, y: 5)
        easyModeButton.layer.contents   = easyModeImage
        
        self.modeSelectionView.addSubview(easyModeButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5) {
            self.modeSelectionView.frame.size.width     = 0
            self.modeSelectionView.frame.size.height    = 0
        }
        
//** Mark: HANDLE EVENT WHEN UIVIEW IS TOUCHED

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
}
