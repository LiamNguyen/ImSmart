//
//  LocationManager.swift
//  ImSmart
//
//  Created by HONG PHUC on 4/29/17.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications
import UIKit

protocol LocationManagerDelegate: class {
    func onEnterRegion()
    func onExitRegion()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private var cllManager : CLLocationManager
    weak var delegate : LocationManagerDelegate?
    
    private override init() {
        cllManager = CLLocationManager()
        super.init()
        cllManager.delegate = self
        cllManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func getRegion() -> CLCircularRegion {
        let myCurrentLocation = CLLocationCoordinate2D(latitude: 60.207943, longitude: 24.663332)
        let region = CLCircularRegion(center: myCurrentLocation, radius: 0.5, identifier: "Home")
        return region
    }
    
    func requestAlwaysAuthorization() {
        cllManager.requestAlwaysAuthorization()
    }
    
    func stopMonitoring() {
        cllManager.stopMonitoring(for: getRegion())
    }
    
    func startMonitoring() {
        cllManager.startMonitoring(for: getRegion())
        cllManager.requestState(for: getRegion())
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) {
            startMonitoring()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
            case .inside:
                print("Enter")
                showNotification(identifier: "enterRegion", title: "Almost home", body: "Do you want to turn some devices on?")
                delegate?.onEnterRegion()
                break
            case .outside:
                print("Exit")
                showNotification(identifier: "exitRegion", title: "Forgot something?", body: "Some devices are still on. Do you want to turn them off?")
                delegate?.onExitRegion()
                break
            default:
                break
        }
    }
    
    func showNotification(identifier: String, title: String, body: String) {
        if #available(iOS 10.0, *) {
            addRequestNotification(request: getRegionNotificationRequest(identifier: identifier, title: title, body: body))
        } else {
            addRequestNotification(title: title, body: body)
        }
    }
    
    /*
     * This method adds notification for iOS version < 10
     */
    func addRequestNotification(title: String, body: String) {
        let notification = UILocalNotification()
        notification.alertTitle = title
        notification.alertBody = body
        notification.fireDate = NSDate().addingTimeInterval(5) as Date
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    @available(iOS 10.0, *)
    func addRequestNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("An error has occurred when trying to add notification: \(error)")
            }
        })
    }
    
    @available(iOS 10.0, *)
    func getRegionNotificationRequest(identifier: String, title: String, body: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let requestIdentifier = identifier
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        return request
    }
}

extension LocationManager: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
