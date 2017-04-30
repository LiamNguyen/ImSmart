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

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared       = LocationManager()
    private var cllManager  : CLLocationManager
    
    private override init() {
        cllManager = CLLocationManager()
        super.init()
        cllManager.delegate = self
        cllManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func getRegion() -> CLCircularRegion {
        let myCurrentLocation = CLLocationCoordinate2D(latitude: Constants.Coordinate.Home.latitude, longitude: Constants.Coordinate.Home.longitude)
        let region = CLCircularRegion(center: myCurrentLocation, radius: Constants.Location.radius, identifier: Constants.Coordinate.Home.identifier)
        return region
    }
    
    func requestAlwaysAuthorization() {
        cllManager.requestAlwaysAuthorization()
    }
    
    func stopMonitoring() {
        cllManager.stopMonitoring(for: getRegion())
    }
    
    func startMonitoring() {
        cllManager.startMonitoring(for: getRegion())    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            startMonitoring()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        notifyRegionChanged(identifier: Constants.NotificationName.enterRegionIdentifier, title: Constants.NotificationName.enterRegionTitle, body: Constants.NotificationName.enterRegionBody)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        notifyRegionChanged(identifier: Constants.NotificationName.exitRegionIdentifier, title: Constants.NotificationName.exitRegionTitle, body: Constants.NotificationName.exitRegionBody)
    }

    private func notifyRegionChanged(identifier: String, title: String, body: String) {
        let appState = UIApplication.shared.applicationState
        if appState == .background {
            showNotification(identifier: identifier, title: title, body: body)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
        }
    }
    
    private func showNotification(identifier: String, title: String, body: String) {
        if #available(iOS 10.0, *) {
            addRequestNotification(request: getNotificationRequest(identifier: identifier, title: title, body: body))
        } else {
            addRequestNotification(title: title, body: body)
        }
    }
    
    /*
     * This method adds notification for iOS version < 10
     */
    private func addRequestNotification(title: String, body: String) {
        let notification = UILocalNotification()
        notification.alertTitle = title
        notification.alertBody = body
        notification.fireDate = NSDate().addingTimeInterval(3) as Date
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    @available(iOS 10.0, *)
    private func addRequestNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("An error has occurred when trying to add notification: \(error)")
            }
        })
    }
    
    @available(iOS 10.0, *)
    private func getNotificationRequest(identifier: String, title: String, body: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let requestIdentifier = identifier
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        return request
    }
}
