//
//  AddLightViewController.swift
//  ImSmart
//
//  Created by Liam Nguyen on 06/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class AddLightViewController: UIViewController {

    @IBOutlet var view_RangingLightsView: JMCRadarView!
    
    fileprivate let beaconManager = JMCBeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeAppearance()
        observeBeaconNotifications()
        startMonitoring()
    }
    
    deinit {
        print("Add light VC -> Dead")
    }
    
    fileprivate func customizeAppearance() {
        self.view.backgroundColor = .black
    }
    
//    ** Mark: OBSERVE FOR NOTIFICATIONS WHEN INTERACTING OR DECTECTING BEACONS
    
    fileprivate func observeBeaconNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(beaconRanged(_:)),
            name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(beaconTapped(_:)),
            name: NSNotification.Name(rawValue: JMCRadarNotifications.BeaconTapped.rawValue),
            object: nil
        )
    }
    
//    ** Mark: BEACON RANGE NOTIFICATION SELECTOR
    
    @objc fileprivate func beaconRanged(_ notification: Notification) {
        if let visibleIbeacons = notification.object as? [iBeacon] {
            for beacon in visibleIbeacons{
                self.view_RangingLightsView.addBeacon(beacon)
            }
        }
    }
    
//    ** Mark: BEACON TAPPED NOTIFICATION SELECTOR
    
    @objc fileprivate func beaconTapped(_ notification: Notification) {
        if let beacon = notification.object as? iBeacon {
            beaconManager.stopMonitoring()
            showAddLightPopUp(lightId: beacon.UUID)
        }
    }
    
//    ** Mark: START MONITORING BEACONS
    
    fileprivate func startMonitoring(){
        //  Check if enabled
        //  beaconManager.registerBeacon("135A1D6C-0B9F-482A-9944-33E230D8AF05")
        
        let beacon = iBeacon(
            minor: Constants.Beacon.TestBeacon.minor,
            major: Constants.Beacon.TestBeacon.major,
            proximityId: Constants.Beacon.TestBeacon.proximityId
        )
        
        beaconManager.registerBeacons(beacons: [beacon])
        beaconManager.startMonitoring({
            print("Successfully dectected a light")
        }) { (messages) in
            print("Error Messages \(messages)")
        }

        beaconManager.logging = false
    }
    
//    ** Mark: SHOW POP UP TO ADD LIGHT
    
    fileprivate func showAddLightPopUp(lightId: String) {
        let alertController = UIAlertController(
            title: Constants.AddLight.AlertView.title,
            message: "\(Constants.AddLight.AlertView.message)\(lightId)",
            preferredStyle: .alert
        )
        
        alertController.addTextField(configurationHandler: nil)
        let textField = alertController.textFields![0]
        textField.placeholder = Constants.AddLight.AlertView.textFieldPlaceHolder
        
        let addAction = UIAlertAction(
            title: Constants.AddLight.AlertView.AddAction.title,
            style: .default) { [weak self] _ in
                if textField.text!.isEmpty {
                    UIFunctionality.applyShakyAnimation(textField, duration: 0.5, repeatCount: 3)
                    self?.showAddLightPopUp(lightId: lightId)
                } else {
                    self?.addLight(area: textField.text!)
                }
        }
        
        let cancelAction = UIAlertAction(
            title: Constants.AddLight.AlertView.CancelAction.title,
            style: .cancel) { [weak self] _ in
                self?.beaconManager.startMonitoring()
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
//    ** Mark: MAKING SERVER REQUEST TO ADD LIGHT
    
    fileprivate func addLight(area: String) {
        let light = LightModel(id: 1, isOn: false, brightness: 0, area: area)
        RemoteStore.sharedInstance.addLight(light.toJSONString()!) { [weak self] success in
            if success {
                self?.performSegue(withIdentifier: Constants.AddLight.SegueIdentifier.toLightVC, sender: self)
            } else {
                self?.showMessage(
                    Constants.Lights.Message.serverError,
                    type: .error,
                    options: [.autoHide(false), .hideOnTap(false), .textNumberOfLines(Constants.longTextLineNumbers), .height(80.0)]
                )
            }
        }
    }
}
