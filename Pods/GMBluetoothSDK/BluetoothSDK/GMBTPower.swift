//
//  BTSDKPower.swift
//  BluetoothSDK
//
//  Created by jake on 2017/3/7.
//  Copyright © 2017年 bomdic. All rights reserved.
//

import UIKit

public class GMBTPower: GMBTSensor {

    //Public
    public var power = -1
    public var powerCadence = -1

    //
    var values: [UInt8] = [] {
        didSet {
            //https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.cycling_power_measurement.xml
            //print("GMBTPower", values)
            
            let powerNow:Int = Int(values[2]) + Int(values[3]) * 256
            powerArray.append(powerNow)
            if powerArray.count > 5 {
                powerArray.remove(at: 0)
            }
            
            var powerSum = 0
            for item in powerArray {
                powerSum = powerSum + item
            }
            power = powerSum / powerArray.count
            
            //有支援Cadence
            var nowCrank: Int = 0
            var nowSecondTimeCrank: Double = 0
            if values[0] == 44 {
                //[44, 0, 0, 0, 169, 166, 2, 0, 231, 12]
                nowCrank = Int(values[6]) + Int(values[7]) * 256
                nowSecondTimeCrank = Double(Int(values[8]) + Int(values[9]) * 256) / 1024.0
                powerCadence = self.calCadence(nowCrank: nowCrank, nowSecondTimeCrank: nowSecondTimeCrank)
            }
            
        }
    }
    
    //
    private var powerArray: [Int] = []

}
