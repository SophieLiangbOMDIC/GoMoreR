//
//  BTSDKHr.swift
//  BluetoothSDK
//
//  Created by jake on 2017/2/24.
//  Copyright © 2017年 bomdic. All rights reserved.
//

import UIKit
import CoreBluetooth

public class GMBTHr: GMBTSensor {
    
    //Public
    public var hr = -1
    
    override public var state: GMBTSensorState {
        didSet {
            if state == GMBTSensorState.disconnect {
                self.hr = -1
            }
        }
    }

}
