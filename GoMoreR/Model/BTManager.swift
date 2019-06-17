//
//  BTManager.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/20.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import GMBluetoothSDK

class BTManager: GMBTManagerDelegate {
    
    static let shared = BTManager()
    
    public let bt = GMBTManager(isScanGoMore: false, isPairOne: true)
   
    init() {
        bt.delegate = self
    }
        
    func managerPowerOff() { }
    
    func hrConnected(btsdkHr: GMBTHr) { }
    
    func cadenceConnected(btsdkCadence: GMBTCadence) { }
    
    func powerConnected(btsdkPower: GMBTPower) { }
    
    func disconnect(type: GMBTSensorType) { }
    
    func sensorInfo() { }
    
    func sensorHr(hr: Int) {
        NotificationCenter.default.post(name: .hrUpdate, object: nil, userInfo: ["hr": hr])
    }
    
    func sensorCadence(cadence: Int) { }
    
    func sensorPower(power: Int) { }
    
}


