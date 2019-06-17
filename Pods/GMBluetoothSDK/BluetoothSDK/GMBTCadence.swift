//
//  BTSDKCadence.swift
//  BluetoothSDK
//
//  Created by jake on 2017/3/7.
//  Copyright © 2017年 bomdic. All rights reserved.
//

import UIKit

public class GMBTCadence: GMBTSensor {
    
    //Public
    public var cadence = -1
    
    //
    var values: [UInt8] = [] {
        didSet {
            //print(values)
            //https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.csc_measurement.xml
            
            var nowCrank: Int = 0
            var nowSecondTimeCrank: Double = 0
            
            if values.count > 0 {
                //只丟Crank
                if values[0] == 2 {
                    nowCrank = Int(values[1]) + Int(values[2]) * 256
                    nowSecondTimeCrank = Double(Int(values[3]) + Int(values[4]) * 256) / 1024.0
                    
                }
                else if values[0] == 3 {
                    nowCrank = Int(values[7]) + Int(values[8]) * 256
                    nowSecondTimeCrank = Double(Int(values[9]) + Int(values[10]) * 256) / 1024.0
                }
                
                //算cadence
                cadence = self.calCadence(nowCrank: nowCrank, nowSecondTimeCrank: nowSecondTimeCrank)
            }
        }
    }
    
}
