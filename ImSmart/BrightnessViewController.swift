//
//  BrightnessViewController.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /09/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BrightnessViewController: UIViewController {

    var lightViewModel                  : LightViewModel!
    
    private var sampleLightBrightness   : UIImageView!
    private var brightnessValueLabel    : UILabel!
    private var adjustBrightnessSlider  : UISlider!
    
    private var sliderValueDidChange    = false
    private let disposalBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = self.lightViewModel else {
            print("Light view model not set")
            return
        }
        
        customizeAppearance()
        
        bindRxObserver()
        bindRxAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = Constants.Brightness.View.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        clearRequireState()
    }
    
    deinit {
        print("Brightness VC -> Dead")
    }
    
    private func bindRxObserver() {
        lightViewModel.brightnessValue.asObservable()
            .map { value in
                return String(Int(value))
        }
        .bindTo(brightnessValueLabel.rx.text)
        .addDisposableTo(disposalBag)
        
        lightViewModel.sampleLightBrightness
        .subscribe(onNext: { [weak self] brightness in
            self?.sampleLightBrightness.layer.backgroundColor = brightness.cgColor
        }).addDisposableTo(disposalBag)
        
        lightViewModel.brightnessValue.asObservable()
            .map({ brightness in
                return Int(brightness)
            })
            .subscribe(onNext: { [weak self] brightness in
                if !(self?.sliderValueDidChange)! {
                    return
                }
                
                for lightCellViewModel in (self?.lightViewModel.selectedLights.value.values)! {
                    lightCellViewModel.brightness.value = brightness
                    if brightness == 0 {
                        lightCellViewModel.isOn.value   = false
                    }
                }
            }).addDisposableTo(disposalBag)
    }
    
    private func bindRxAction() {
        
    }
    
//** Mark: SUPPORT FUNCTIONS
    
    private func clearRequireState() {
//        Clear selected lights
        lightViewModel.selectedLights.value.removeAll()
        
//        Set default brightness value
        lightViewModel.brightnessValue.value = 0.0
        
//        Set default requireCellShake variable
        lightViewModel.requireCellShake.value = false
    }

    private func customizeAppearance() {
        drawSampleImage()
        drawBrightnessValueLabel()
        drawBrightnessSlider()
    }
    
//** Mark: DRAWING BRIGHTNESS EXAMPLE IMAGE
    
    private func drawSampleImage() {
        let sampleImage                                     = UIImage(named: Constants.Brightness.View.brightnessExample)
        
        self.sampleLightBrightness                          = UIImageView(image: sampleImage)
        self.sampleLightBrightness.frame                    = CGRect(x: 0, y: 0, width: 220, height: 330)
        self.sampleLightBrightness.layer.backgroundColor    = UIColor.yellow.cgColor
        self.sampleLightBrightness.contentMode              = UIViewContentMode.scaleToFill
        
        self.view.addSubview(self.sampleLightBrightness)
        addImageViewConstraints()
    }

    private func drawBrightnessValueLabel() {
        self.brightnessValueLabel                            = UILabel()
        
        self.brightnessValueLabel.adjustsFontSizeToFitWidth  = true
        self.brightnessValueLabel.textAlignment              = .center
        self.brightnessValueLabel.font                       = UIFont.systemFont(ofSize: 40, weight: UIFontWeightSemibold)
        
        self.view.addSubview(self.brightnessValueLabel)
        addLabelConstraints()
    }
    
    private func drawBrightnessSlider() {
        self.adjustBrightnessSlider                 = UISlider(frame: CGRect(x: 0, y: 0, width: 220, height: 40))
        
        self.adjustBrightnessSlider.minimumValue    = 0
        self.adjustBrightnessSlider.maximumValue    = 100
        self.adjustBrightnessSlider.isContinuous    = true
        self.adjustBrightnessSlider.tintColor       = UIColor.red
        self.adjustBrightnessSlider.value           = 0
        self.adjustBrightnessSlider.addTarget(self, action: #selector(self.sliderValueChange), for: .valueChanged)
        
        self.view.addSubview(self.adjustBrightnessSlider)
        addSliderConstraints()
    }
    
    @objc func sliderValueChange(sender: UISlider) {
        self.sliderValueDidChange               = !self.sliderValueDidChange
        let sliderValueStep: Float              = 5
        let roundedValue                        = round(sender.value / sliderValueStep) * sliderValueStep
        self.adjustBrightnessSlider.value       = roundedValue

        lightViewModel.brightnessValue.value    = roundedValue
    }
    
//** Mark: MAKE CONSTRAINTS

    private func addImageViewConstraints() {
        self.sampleLightBrightness.snp.makeConstraints { maker in
            maker.width.equalTo(220)
            maker.height.equalTo(330)
            maker.top.equalTo(self.view.snp.top).offset(100)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func addLabelConstraints() {
        self.brightnessValueLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.sampleLightBrightness.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func addSliderConstraints() {
        self.adjustBrightnessSlider.snp.makeConstraints { maker in
            maker.width.equalTo(220)
            maker.height.equalTo(40)
            maker.top.equalTo(self.brightnessValueLabel.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
        }
    }
}
