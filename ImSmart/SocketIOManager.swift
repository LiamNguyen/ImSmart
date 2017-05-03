//
//  SocketIOManager.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /22/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift

class SocketIOManager {
    static let sharedInstance = SocketIOManager()
    
    private var socket = SocketIOClient(
        socketURL: URL(string: "\(SocketServerURL.school.rawValue):\(SocketServerPort.generalPort.rawValue)")!
    )
    
    var isDeviceConnectedToSocket = Variable(false)
    
    private init() {
        socket.on(SocketKey.connect.rawValue) { [unowned self] _ in
            self.isDeviceConnectedToSocket.value = true
            print("Device connected")
        }
        
        socket.on(SocketKey.disconnect.rawValue) { [unowned self] _ in
            self.isDeviceConnectedToSocket.value = false
            print("Device disconnected")
        }
        
        socket.on(SocketKey.notifyOthersForLightsUpdate.rawValue) { _ in
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: Constants.NotificationName.requiredUpdateLights),
                object: nil
            )
        }
        
        socket.on(SocketKey.notifyOthersForAirConssUpdate.rawValue) { _ in
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: Constants.NotificationName.requiredUpdateAirCons),
                object: nil
            )
        }
    }
    
    func socketConnect() {
        socket.connect()
    }
    
    func socketDisconnect() {
        socket.disconnect()
    }
    
    func registerDevice() {
        socket.on(SocketKey.connect.rawValue) { [unowned self] _ in
            self.socket.emit(SocketKey.registerDevice.rawValue, Constants.deviceUUID, Constants.deviceName)
        }
    }
    
    func onReceiveNotificationWhenOthersRegistered() {
        socket.on(SocketKey.notifyOthersWhenConnected.rawValue) { (notifyMessageArray, ack) in
            print(notifyMessageArray[0])
        }
    }
    
    func onReceiveConnectedConfirmation(completionHandler: @escaping ( (_ welcomeMessage: String) -> Void) ) {
        socket.on(SocketKey.confirmRegistered.rawValue) { (welcomeMessageArray, ack) in
            completionHandler(welcomeMessageArray[0] as! String)
        }
    }
    
    func requireUpdateLights() {
        socket.emit(SocketKey.requireUpdateLights.rawValue)
    }
    
    func requireUpdateAirConditioners() {
        socket.emit(SocketKey.requireUpdateAirCons.rawValue)
    }
    
    private enum SocketKey: String {
        case connect                        = "connect"
        case disconnect                     = "disconnect"
        case registerDevice                 = "registerDevice"
        case notifyOthersWhenConnected      = "notifyOthersWhenConnected"
        case confirmRegistered              = "confirmRegistered"
        case requireUpdateLights            = "requireUpdateLights"
        case notifyOthersForLightsUpdate    = "notifyOthersForLightsUpdate"
        case requireUpdateAirCons           = "requireUpdateAirCons"
        case notifyOthersForAirConssUpdate  = "notifyOthersForAirConssUpdate"
    }
    
    private enum SocketServerURL: String {
        case edenred    = "http://192.168.2.69"
        case home       = "http://192.168.20.106"
        case school     = "http://10.112.200.229"
    }
    
    private enum SocketServerPort: String {
        case generalPort = "1208"
    }
}
