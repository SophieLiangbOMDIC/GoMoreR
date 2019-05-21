//
//  BTSDKSensor.swift
//  BluetoothSDK
//
//  Created by jake on 2017/3/8.
//  Copyright © 2017年 bomdic. All rights reserved.
//

import UIKit
import CoreBluetooth

//
let SECONDS_WAIT_CONNECT = 5

//
public enum GMBTSensorState {
    case disconnect
    case connecting
    case connected
    case reconnect
}

public class GMBTSensor: NSObject {
    
    public init(name: String?, peripheral: CBPeripheral?) {
        self.name = name
        self.uuid = peripheral?.identifier.uuidString
        self.peripheral = peripheral
    }
    
    //Public
    public var name: String?
    public var uuid: String?
    public var model: String?
    public var serial: String?
    public var firmware: String?
    public var battery = -1
    public var state: GMBTSensorState = GMBTSensorState.disconnect {
        didSet {
            if state == GMBTSensorState.disconnect {
                self.model = ""
                self.serial = ""
                self.firmware = ""
                self.battery = -1
            }
            else if state == GMBTSensorState.connecting {
                var c = 0
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                    if self.state == GMBTSensorState.connected {
                        timer.invalidate()
                    }
                    else if self.state == GMBTSensorState.connecting && c >= SECONDS_WAIT_CONNECT {
                        self.state = GMBTSensorState.disconnect
                        timer.invalidate()
                    }
                    
                    c = c + 1
                })
            }
        }
    }
    
    //Private
    var peripheral: CBPeripheral?
    var reconnectTimer: Timer?
    var batteryCharacteristic: CBCharacteristic?
    
    private var cadence = -1
    private var crankArray: [Int] = []
    private var secondTimeCrankArray: [Double] = []
    
    //連線成功
    class func success(sensor: GMBTSensor) {
        if sensor.reconnectTimer != nil {
            sensor.reconnectTimer?.invalidate()
            sensor.reconnectTimer = nil
        }
        
        sensor.state = GMBTSensorState.connected
    }
    
    func calCadence(nowCrank: Int, nowSecondTimeCrank:Double) -> Int {
        var tCadence = 0

        crankArray.append(nowCrank)
        secondTimeCrankArray.append(nowSecondTimeCrank)
        
        if crankArray.count < 5 {
            //tCadence = Int(Double(nowCrank) / nowSecondTimeCrank * 60.0)
        }
        else {
            let crankDiff = crankArray[crankArray.count - 1] - crankArray[0]
            let secondDiff = secondTimeCrankArray[secondTimeCrankArray.count - 1] - secondTimeCrankArray[0]
            if crankDiff > 0 && secondDiff > 0 {
                tCadence = Int(Double(crankDiff) / secondDiff * 60.0)
            }
            else if (crankDiff < 0 && secondDiff > 0) || (crankDiff > 0 && secondDiff < 0) {
                tCadence = cadence
            }
            
            crankArray.remove(at: 0)
            secondTimeCrankArray.remove(at: 0)
        }
        
        cadence = tCadence

        return cadence
    }
    
}
