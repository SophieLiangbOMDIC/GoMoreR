//
//  GMBTHrUrun.swift
//  GMBluetoothSDK
//
//  Created by JakeChang on 2019/5/20.
//  Copyright © 2019 bomdic. All rights reserved.
//

import UIKit
import CoreBluetooth

public class GMBTHrUrun: GMBTHr {

    public var rri = ""
    public var acc = ""
    public var gyr = ""
    public var ecg = ""
    public var res = ""
    
    var urunCharacteristic: CBCharacteristic?
    var urunValues = ""
    var urunHexString = ""
    
    //U-RUN Sensor 送出命令，用以取得Data
    public func getUrun() {
        if self.peripheral != nil && self.urunCharacteristic != nil {
            
            //let bytes : [UInt8] = [0x53, 0x59, 0x53, 0x20, 0x73, 0x74, 0x61, 0x72, 0x74, 0x20, 0x64, 0x61, 0x74, 0x20, 0x30, 0x30, 0x33, 0x46, 0x0D, 0x0A]
            let bytes : [UInt8] = [0x53, 0x59, 0x53, 0x20, 0x73, 0x74, 0x61, 0x72, 0x74, 0x20, 0x64, 0x61, 0x74, 0x20, 0x30, 0x30, 0x30, 0x66, 0x0D, 0x0A]
            let data = NSData(bytes: bytes, length: bytes.count)
            
            let str = "URUN get HR\r\n"
            let data2 = str.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            
            
            
            //self.peripheral?.writeValue(data as Data, for: self.urunCharacteristic!, type: CBCharacteristicWriteType.withResponse)
            self.peripheral?.writeValue(data2!, for: self.urunCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    public func urunData(hexString: String) {
        print("urunData", hexString)
        
        if urunHexString == "" {
            if hexString.contains("2b4441543a") {
                let array = hexString.components(separatedBy: "2b4441543a")
                urunHexString = array[1]
            }
        }
        else {
            if hexString.contains("2b4441543a") {
                let array = hexString.components(separatedBy: "2b4441543a")
                urunHexString = urunHexString + array[0]
                
                if urunHexString.count >= 1736 {
                    let lenB = switchHexStr(s: sub(s: urunHexString, start: 0, end: 4))
                    let type = switchHexStr(s: sub(s: urunHexString, start: 4, end: 8))
                    let timeStr = switchHexStr(s: sub(s: urunHexString, start: 8, end: 12))
                    let hr = sub(s: urunHexString, start: 12, end: 14)
                    let time = Int(timeStr, radix: 16)
                    
                    //RRI 14~30
                    let rriStr1 = switchHexStr(s: sub(s: urunHexString, start: 14, end: 18))
                    let rriStr2 = switchHexStr(s: sub(s: urunHexString, start: 18, end: 22))
                    let rriStr3 = switchHexStr(s: sub(s: urunHexString, start: 22, end: 26))
                    let rriStr4 = switchHexStr(s: sub(s: urunHexString, start: 26, end: 30))
                    let rri1 = Int(rriStr1, radix: 16)
                    let rri2 = Int(rriStr2, radix: 16)
                    let rri3 = Int(rriStr3, radix: 16)
                    let rri4 = Int(rriStr4, radix: 16)
                    
                    rri = String(describing: rri1!) + "," + String(describing: rri2!) + "," + String(describing: rri3!) + "," + String(describing: rri4!)
                    
                    //ACC 30~630
                    var tAcc = ""
                    var i = 30
                    while i < 630 {
                        let accStr = switchHexStr(s: sub(s: urunHexString, start: i, end: i+4))
                        let acc = Int(accStr, radix: 16)
                        
                        if tAcc == "" {
                            tAcc = String(describing: acc!)
                        }
                        else {
                            tAcc = tAcc + "," + String(describing: acc!)
                        }
                        
                        i = i + 4
                    }
                    acc = tAcc
                    
                    //GYR 630~1230
                    var tGyr = ""
                    i = 630
                    while i < 1230 {
                        let gyrStr = switchHexStr(s: sub(s: urunHexString, start: i, end: i+4))
                        let gyr = Int(gyrStr, radix: 16)
                        
                        if tGyr == "" {
                            tGyr = String(describing: gyr!)
                        }
                        else {
                            tGyr = tGyr + "," + String(describing: gyr!)
                        }
                        
                        i = i + 4
                    }
                    gyr = tGyr
                    
                    //RES
                    let resStr = sub(s: urunHexString, start: 1230, end: 1232)
                    res = String(Int(resStr, radix: 16)!)
                    
                    //ECG 1232~1732
                    var tEcg = ""
                    i = 1232
                    while i < 1732 {
                        let ecgStr = switchHexStr(s: sub(s: urunHexString, start: i, end: i+4))
                        let ecg = Int(ecgStr, radix: 16)
                        
                        if tEcg == "" {
                            tEcg = String(describing: ecg!)
                        }
                        else {
                            tEcg = tEcg + "," + String(describing: ecg!)
                        }
                        
                        i = i + 4
                    }
                    ecg = tEcg
                    
                }
                
                urunHexString = array[1]
                urunHexString = urunHexString.replacingOccurrences(of: "2b4441543a", with: "")
            }
            else {
                urunHexString = urunHexString + hexString
            }
        }
        
    }
    
    private func sub(s: String, start: Int, end: Int) -> String {
        let range = s.index(s.startIndex, offsetBy: start) ..< s.index(s.startIndex, offsetBy: end)
        return s.substring(with: range)
    }
    
    private func switchHexStr(s: String) -> String {
        let a = sub(s: s, start: 0, end: 2)
        let b = sub(s: s, start: 2, end: 4)
        return b + a
    }
}
