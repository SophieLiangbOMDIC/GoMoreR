//
//  GMBTHrCodoon.swift
//  GMBluetoothSDK
//
//  Created by JakeChang on 2019/5/20.
//  Copyright © 2019 bomdic. All rights reserved.
//

import UIKit
import CoreBluetooth

public class GMBTHrCodoon: GMBTHr {

    var codoonTimer: Timer?
    
    public func getCodoon() {
        guard let characteristic = batteryCharacteristic else {
            return
        }
        
        let bytes : [UInt8] = [0xAA, 0x04, 0x07, 0x00, 0x04, 0x00, 0x00, 0x00, 0x03, 0xBC]
        let data = NSData(bytes: bytes, length: bytes.count)
        
        if name == "COD_WATCH" {
            self.codoonTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { timer in
                self.peripheral?.setNotifyValue(true, for: characteristic)
                self.peripheral?.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
            })
        }
        else if name == "COD_BAND" {
            self.peripheral?.setNotifyValue(true, for: characteristic)
            self.peripheral?.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    public func stopCodoon() {
        if self.peripheral != nil && self.batteryCharacteristic != nil {
            if self.codoonTimer != nil {
                self.codoonTimer?.invalidate()
                self.codoonTimer = nil
            }
            
            let bytes : [UInt8] = [0xAA, 0x04, 0x07, 0x00, 0x04, 0x00, 0x00, 0x01, 0x03, 0xBD]
            let data = NSData(bytes: bytes, length: bytes.count)
            
            self.peripheral?.setNotifyValue(true, for: self.batteryCharacteristic!)
            self.peripheral?.writeValue(data as Data, for: self.batteryCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
}
