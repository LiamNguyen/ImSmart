//
//  JMCBluetoothManager.swift
//  iBeaconManager
//
//  Created by Janusz Chudzynski on 6/21/16.
//  Copyright © 2016 Janusz Chudzynski. All rights reserved.
//

import Foundation
import CoreBluetooth
/**Bluetooth manager - responsible for getting the status of Bluetooth.*/
class BluetoothManager: NSObject, CBCentralManagerDelegate {
    
    var centralManager:CBCentralManager!
    var blueToothReady = false
    var callback:((Bool)->Void)!
    var enabled = false
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey:false])
    }
    
    convenience init(callback:@escaping (Bool)->Void)
    {
        self.init()
        self.callback = callback
        
    }
    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            enabled = true
            callback(true)
        }
        else{
            enabled = false
            callback(false)
        }
    }
    
}
