//
//  BTSDKManager.swift
//  BluetoothSDK
//
//  Created by jake on 2017/2/24.
//  Copyright © 2017年 bomdic. All rights reserved.
//

import UIKit
import CoreBluetooth

let SECONDS_CLEAR_SENSOR = 10.0

let UUID_SCAN_HR = "180D"
let UUID_SCAN_CADENCE = "1816"
let UUID_SCAN_POWER = "1818"
let UUID_MODEL = "2A24"
let UUID_SERIAL = "2A25"
let UUID_FIRMWARE = "2A26"
let UUID_BATTERY = "2A19"
let UUID_HR = "2A37"
let UUID_CADENCE = "2A5B"
let UUID_POWER = "2A63"

let UUID_SCAN_CODOON_HR1 = "180F"
let UUID_SCAN_CODOON_HR2 = "FE95"

public protocol GMBTManagerDelegate {
    func managerPowerOff()
    
    func hrConnected(btsdkHr: GMBTHr)
    func cadenceConnected(btsdkCadence: GMBTCadence)
    func powerConnected(btsdkPower: GMBTPower)
    
    func hrDisconnect()
    func cadenceDisconnect()
    func powerDisconnect()
    
    func sensorInfo()
    func sensorHr(hr: Int)
    func sensorCadence(cadence: Int)
    func sensorPower(power: Int)
}

public enum GMBTSensorType: Int {
    case hr = 0
    case cadence = 1
    case power = 2
    
    var uuid: String {
        switch self {
        case .hr:
            return UUID_SCAN_HR
        case .cadence:
            return UUID_SCAN_CADENCE
        case .power:
            return UUID_SCAN_POWER
        }
    }
}

public class GMBTManager: NSObject {
    
    //Public
    public var delegate: GMBTManagerDelegate?
    public var isScanGoMore = true //是否只能配對GoMore Sensor
    public var isPairOne = true
    
    public var hrArray: [GMBTHr] = []
    public var cadenceArray: [GMBTCadence] = []
    public var powerArray: [GMBTPower] = []
    
    public init(isScanGoMore: Bool, isPairOne: Bool) {
        self.isScanGoMore = isScanGoMore
        self.isPairOne = isPairOne
    }
    
    //Private
    var centralManager: CBCentralManager?
    var serviceArray: [CBUUID] = []
    var clearTimer: Timer?
    
    var isPoweredOff = false
    var isPoweredOn = false
    
    var saveUUIDs: GMBTSaveUUIDs?
    
    //目前藍芽狀況
    public func scan(type: [GMBTSensorType],
                     poweredOff: @escaping () -> Void,
                     poweredOn: @escaping () -> Void,
                     poweredOther: @escaping () -> Void)
    {
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            saveUUIDs = GMBTSaveUUIDs()
            
            //
            for item in type {
                serviceArray.append(CBUUID(string: item.uuid))
                
                //咕咚
                if !self.isScanGoMore {
                    serviceArray.append(CBUUID(string: UUID_SCAN_CODOON_HR1))
                    serviceArray.append(CBUUID(string: UUID_SCAN_CODOON_HR2))
                }
            }
            
            //每幾秒清除沒有連線過的sensor
            if clearTimer == nil {
                clearTimer = Timer.scheduledTimer(withTimeInterval: SECONDS_CLEAR_SENSOR, repeats: true, block: { timer in
                    if self.serviceArray.contains(CBUUID(string: UUID_SCAN_HR)) {
                        self.hrArray.removeAll(where: { $0.state == .disconnect })
                    }
                    
                    if self.serviceArray.contains(CBUUID(string: UUID_SCAN_CADENCE)) {
                        self.cadenceArray.removeAll(where: { $0.state == .disconnect })
                    }
                    
                    if self.serviceArray.contains(CBUUID(string: UUID_SCAN_POWER)) {
                        self.powerArray.removeAll(where: { $0.state == .disconnect })
                    }
                    
                    //
                    self.scanSetting()
                })
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            timer.invalidate()

            if self.isPoweredOff {
                poweredOff()
            }
            else if self.isPoweredOn {
                poweredOn()
            }
            else {
                poweredOther()
            }
        })
    }
    
    //連線
    public func connect(sensor: GMBTSensor, type: GMBTSensorType) {
        var isConnectSensor = false
        switch type {
        case .hr:
            isConnectSensor = isConnect(sensorArray: self.hrArray)
            
        case .cadence:
            isConnectSensor = isConnect(sensorArray: self.cadenceArray)
            
        case .power:
            isConnectSensor = isConnect(sensorArray: self.powerArray)
        }
        
        if !(self.isPairOne && isConnectSensor) {
            if sensor.state == .disconnect { sensor.state = .connecting }
            centralManager?.connect(sensor.peripheral!, options: nil)
        }
    }
    
    //主動斷線
    public func disconnect(sensor: GMBTSensor) {
        if sensor.state == GMBTSensorState.connected, let peripheral = sensor.peripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
        else if sensor.state == GMBTSensorState.reconnect {
            sensor.state = GMBTSensorState.disconnect
            sensor.reconnectTimer?.invalidate()
            sensor.reconnectTimer = nil
        }
        
        saveUUIDs?.deleteUUIDArray(uuid: sensor.uuid ?? "")
    }
    
    //取得電量
    public func battery(sensor: GMBTSensor) {
        if sensor.peripheral != nil && sensor.batteryCharacteristic != nil {
            sensor.peripheral?.readValue(for: sensor.batteryCharacteristic!)
        }
    }
    
    func scanSetting() {
        let array = self.centralManager?.retrieveConnectedPeripherals(withServices: [CBUUID(string: UUID_SCAN_HR)]) ?? []
        for item in array {
            //print(item.name, item.identifier.description)
            
            if let name = item.name {
                if let sensorName = filterName(name: name, isScanGoMore: self.isScanGoMore) {
                    saveSensor(type: .hr, name: sensorName, peripheral: item)
                }
            }
        }
    }
    
    func filterFrom(sensorArray: [GMBTSensor] , uuid: String) -> GMBTSensor? {
        return sensorArray.filter { $0.uuid == uuid }.first
    }
    
    //全部設成斷線
    func disconnect(sensorArray: [GMBTSensor]) {
        for btsensor in sensorArray {
            btsensor.state = .disconnect
        }
    }
    
    //是否已經連線
    func isConnect(sensorArray: [GMBTSensor]) -> Bool {
        var isConnected = false
        for btsensor in sensorArray {
            if btsensor.state == .connected || btsensor.state == .connecting {
                isConnected = true
                break
            }
        }
        return isConnected
    }
    
    func filterName(name: String, isScanGoMore: Bool) -> String? {
        var sensorName: String? = nil
        
        //GoMore Lite
        if name.contains("GM101B") || name.contains("GB101B") {
            sensorName = name
            sensorName = sensorName?.replacingOccurrences(of: "GM101B", with: "")
            sensorName = sensorName?.replacingOccurrences(of: "GB101B", with: "")
            sensorName = "GoMore Lite: " + (sensorName?.uppercased())!
        }
        else if name.contains("GoMore") {
            sensorName = name
        }
        else {
            sensorName = isScanGoMore ? nil : name
        }
        
        return sensorName
    }
    
    func saveSensor(type: GMBTSensorType, name: String, peripheral: CBPeripheral) {
        switch type {
        case .hr:
            if !hrArray.contains(where: { $0.name == name }) {
                let hr = GMBTHr(name: name, peripheral: peripheral)
                hrArray.append(hr)
            }
            
        case .cadence:
            if !cadenceArray.contains(where: { $0.name == name }) {
                let cadence = GMBTCadence(name: name, peripheral: peripheral)
                cadenceArray.append(cadence)
            }
            
        case .power:
            if !powerArray.contains(where: { $0.name == name }) {
                let power = GMBTPower(name: name, peripheral: peripheral)
                powerArray.append(power)
            }
        }
    }
    
    func getSensor(uuid: String) -> GMBTSensor? {
        var sensor: GMBTSensor?
        
        if let btsdkHr = filterFrom(sensorArray: hrArray, uuid: uuid) {
            sensor = btsdkHr
        }
        else if let btsdkCadence = filterFrom(sensorArray: cadenceArray, uuid: uuid) {
            sensor = btsdkCadence
        }
        else if let btsdkPower = filterFrom(sensorArray: powerArray, uuid: uuid) {
            sensor = btsdkPower
        }
        
        return sensor
    }
}

extension GMBTManager: CBCentralManagerDelegate {
    // from CBCentralManager.init(delegate: self, queue: nil)
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("poweredOff")
            isPoweredOff = true
            
            //停止掃描
            if let manager = centralManager, manager.isScanning {
                centralManager?.stopScan()
            }
            
            //全部設成斷線
            disconnect(sensorArray: hrArray)
            disconnect(sensorArray: cadenceArray)
            disconnect(sensorArray: powerArray)
            
            //
            self.delegate?.managerPowerOff()
            
        case .poweredOn:
            print("poweredOn")
            isPoweredOn = true
            
            //
            self.scanSetting()
            
            //開始掃瞄
            centralManager?.scanForPeripherals(withServices: serviceArray,
                                               options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])

        case .resetting, .unauthorized, .unknown, .unsupported:
            break
        }
    }
    
    // from centralManager?.scanForPeripherals(withServices: serviceArray, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print(advertisementData)
        
        if let sensorName = advertisementData["kCBAdvDataLocalName"] as? String,
           let uuid = advertisementData["kCBAdvDataServiceUUIDs"] as? [Any] {
            //print(sensorName, RSSI)
            
            //過濾Sensor Name
            let info = uuid.description.lowercased()
            if info.contains("heart") {
                if let sensorName = filterName(name: sensorName, isScanGoMore: self.isScanGoMore) {
                    saveSensor(type: .hr, name: sensorName, peripheral: peripheral)
                }
            }
            else if info.contains("cadence") {
                saveSensor(type: .cadence, name: sensorName, peripheral: peripheral)
            }
            else if info.contains("1818") {
                saveSensor(type: .power, name: sensorName, peripheral: peripheral)
            }
            else if info.range(of: "battery") != nil {
                //咕咚: 用電池的UUID來取得HR
                saveSensor(type: .hr, name: sensorName, peripheral: peripheral)
            }
            
            //如果已經連線過，主動連線
            let uuid = peripheral.identifier.uuidString
            if let saveUUIDs = saveUUIDs, saveUUIDs.findUUIDFromUUIDArray(uuid: uuid) {
                if let btsdkHr = filterFrom(sensorArray: hrArray, uuid: uuid) {
                    connect(sensor: btsdkHr, type: .hr)
                }
                else if let btsdkCadence = filterFrom(sensorArray: cadenceArray, uuid: uuid) {
                    connect(sensor: btsdkCadence, type: .cadence)
                }
                else if let btsdkPower = filterFrom(sensorArray: powerArray, uuid: uuid) {
                    connect(sensor: btsdkPower, type: .power)
                }
            }
        }
        else if let sensorName: String = advertisementData["kCBAdvDataLocalName"] as! String?, sensorName == "COD_WATCH" {
            //print(sensorName, RSSI)
            saveSensor(type: .hr, name: sensorName, peripheral: peripheral)
        }
        
    }
    
    //
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect")
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
        
        let uuid = peripheral.identifier.uuidString
        if let btsdkHr = filterFrom(sensorArray: hrArray, uuid: uuid) {
            doReconnectTimer(sensor: btsdkHr, type: .hr)
            self.delegate?.hrDisconnect()
        }
        
        if let btsdkCadence = filterFrom(sensorArray: cadenceArray, uuid: uuid) {
            doReconnectTimer(sensor: btsdkCadence, type: .cadence)
            self.delegate?.cadenceDisconnect()
        }
        
        if let btsdkPower = filterFrom(sensorArray: powerArray, uuid: uuid) {
            doReconnectTimer(sensor: btsdkPower, type: .power)
            self.delegate?.powerDisconnect()
        }
    }
    
    func doReconnectTimer(sensor: GMBTSensor, type: GMBTSensorType) {
        sensor.state = GMBTSensorState.disconnect
        /*
         //如果已經連線過，主動重試連線
         if (saveUUIDs?.findUUIDFromUUIDArray(uuid: (sensor.uuid)!))! {
         sensor.state = GMBTSensorState.reconnect
         if sensor.reconnectTimer == nil {
         var c = 0
         sensor.reconnectTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
         self.connect(sensor: sensor, type: type)
         
         c = c + 3
         
         //重試超過超過幾秒就不重連
         if c > 30 {
         sensor.state = GMBTSensorState.disconnect
         sensor.reconnectTimer?.invalidate()
         sensor.reconnectTimer = nil
         }
         })
         }
         }*/
    }
}

extension GMBTManager: CBPeripheralDelegate {
    //
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //print(error, peripheral.services)
        
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
        //成功連線
        var sensor: GMBTSensor?
        let uuid = peripheral.identifier.uuidString
        if let btsdkHr = filterFrom(sensorArray: hrArray, uuid: uuid) as? GMBTHr {
            self.delegate?.hrConnected(btsdkHr: btsdkHr)
            sensor = btsdkHr
        }
        else if let btsdkCadence = filterFrom(sensorArray: cadenceArray, uuid: uuid) as? GMBTCadence {                self.delegate?.cadenceConnected(btsdkCadence: btsdkCadence)
            sensor = btsdkCadence
        }
        else if let btsdkPower = filterFrom(sensorArray: powerArray, uuid: uuid) as? GMBTPower {
            self.delegate?.powerConnected(btsdkPower: btsdkPower)
            sensor = btsdkPower
        }
        
        if let sensor = sensor {
            GMBTSensor.success(sensor: sensor)
            saveUUIDs?.saveToUUIDArray(uuid: sensor.uuid ?? "")
        }
    }
    
    //
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //print(service.characteristics)
        
        guard error == nil else { return }
        
        let uuid = peripheral.identifier.uuidString
        
        for characteristic in service.characteristics ?? [] {
            //print(characteristic.uuid.uuidString)
            
            switch characteristic.uuid.uuidString {
            case UUID_MODEL, UUID_SERIAL, UUID_FIRMWARE:
                peripheral.readValue(for: characteristic)
                
            case UUID_BATTERY:
                peripheral.readValue(for: characteristic)
                
                if let sensor = getSensor(uuid: uuid) {
                    sensor.batteryCharacteristic = characteristic
                    
                    //咕咚
                    if let codoonHr = sensor as? GMBTHrCodoon {
                        codoonHr.getCodoon()
                    }
                }
            
            case UUID_HR, UUID_CADENCE, UUID_POWER, "6E400003-B5A3-F393-E0A9-E50E24DCCA9E":
                peripheral.setNotifyValue(true, for: characteristic)
                
            case "6E400002-B5A3-F393-E0A9-E50E24DCCA9E":
                if let hrUrun = filterFrom(sensorArray: hrArray, uuid: uuid) as? GMBTHrUrun {
                    hrUrun.urunCharacteristic = characteristic
                }
                
            default:
                break
            }
        }
    }
    
    //
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("data: ", characteristic.value)
        //print("didUpdateValueFor", characteristic.uuid.uuidString)
        
        if let data = characteristic.value {
            
            var values = [UInt8](repeating:0, count:data.count)
            data.copyBytes(to: &values, count: data.count)
            
            let uuid = peripheral.identifier.uuidString
            
            switch characteristic.uuid.uuidString {
                
            case UUID_MODEL:
                if let model = String(data: data, encoding: .utf8) {
                    print("model", model)
                    
                    if let sensor = getSensor(uuid: uuid) {
                        sensor.model = model
                        self.delegate?.sensorInfo()
                    }
                }
                
            case UUID_SERIAL:
                if let serial:String = String(data: data, encoding: .utf8) {
                    print("serial", serial)
                    
                    if let sensor = getSensor(uuid: uuid) {
                        sensor.serial = serial
                        self.delegate?.sensorInfo()
                    }
                }
                
            case UUID_FIRMWARE:
                if let firmware:String = String(data: data, encoding: .utf8) {
                    print("firmware", firmware)
                    
                    if let sensor = getSensor(uuid: uuid) {
                        sensor.firmware = firmware
                        self.delegate?.sensorInfo()
                    }
                }
                
            case UUID_BATTERY:
                let battery = Int(values[0])
                print("battery", battery)

                if let sensor = getSensor(uuid: uuid) {
                    sensor.battery = battery
                    self.delegate?.sensorInfo()
                    
                    //咕咚
                    if let name = sensor.name, (name == "COD_WATCH" || name == "COD_BAND") && values.count >= 9, let codoonHr = sensor as? GMBTHr {
                        codoonHr.hr = Int(values[8])
                        self.delegate?.sensorHr(hr: codoonHr.hr)
                    }
                }
                
            case UUID_HR:
                let hr = Int(values[1])
            
                if let btsdkHr = filterFrom(sensorArray: hrArray, uuid: uuid) as? GMBTHr {
                    btsdkHr.hr = hr
                    self.delegate?.sensorHr(hr: btsdkHr.hr)
                }
                
            case "6E400003-B5A3-F393-E0A9-E50E24DCCA9E":
                //let string:String = String(data: data!, encoding: .utf8)!
                //print("E50E24DCCA9E", string)
                //print(values)

                let hexString = NSMutableString()
                for byte in values {
                    hexString.appendFormat("%02x", UInt(byte))
                }
            
                if let hrUrun = filterFrom(sensorArray: hrArray, uuid: uuid) as? GMBTHrUrun {
                    hrUrun.urunData(hexString: hexString as String)
                }
                
            case UUID_CADENCE:
                if let btsdkCadence = filterFrom(sensorArray: cadenceArray, uuid: uuid) as? GMBTCadence {
                    btsdkCadence.values = values
                    self.delegate?.sensorCadence(cadence: btsdkCadence.cadence)
                }
                
            case UUID_POWER:
                if let btsdkPower = filterFrom(sensorArray: powerArray, uuid: uuid) as? GMBTPower {
                    btsdkPower.values = values
                    self.delegate?.sensorPower(power: btsdkPower.power)
                }
                
            default:
                break
            }
        }
    }
}
