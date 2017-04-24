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
        socketURL: URL(string: "\(Constants.SocketIO.socketServerURL):\(Constants.SocketIO.socketServerPort)")!
    )
    
    var isDeviceConnectedToSocket = Variable(false)
    
    private init() {
        socket.on(SocketKey.connect.rawValue) { [weak self] _ in
            self?.isDeviceConnectedToSocket.value = true
            print("Device connected")
        }
        
        socket.on(SocketKey.disconnect.rawValue) { [weak self] _ in
            self?.isDeviceConnectedToSocket.value = false
            print("Device disconnected")
        }
    }
    
    func socketConnect() {
        socket.connect()
    }
    
    func socketDisconnect() {
        socket.disconnect()
    }
    
    func registerDevice() {
        socket.on(SocketKey.connect.rawValue) { [weak self] _ in
            self?.socket.emit(SocketKey.registerDevice.rawValue, Constants.deviceUUID, Constants.deviceName)
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
    
    func onReceiveRequireLightsUpdate(completionHandler: @escaping ( () -> Void)) {
        socket.on(SocketKey.notifyOthersForLightsUpdate.rawValue) { _ in
            completionHandler()
        }
    }
    
    private enum SocketKey: String {
        case connect                        = "connect"
        case disconnect                     = "disconnect"
        case registerDevice                 = "registerDevice"
        case notifyOthersWhenConnected      = "notifyOthersWhenConnected"
        case confirmRegistered              = "confirmRegistered"
        case requireUpdateLights            = "requireUpdateLights"
        case notifyOthersForLightsUpdate    = "notifyOthersForLightsUpdate"
    }
}