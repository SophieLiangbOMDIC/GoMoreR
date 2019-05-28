//
//  BTSDKSaveUUIDs.swift
//  BluetoothSDK
//
//  Created by jake on 2017/3/7.
//  Copyright © 2017年 bomdic. All rights reserved.
//

import UIKit

let USERDEFAULTS_UUIDARRAY = "USERDEFAULTS_UUIDARRAY"

class GMBTSaveUUIDs: NSObject {
        
    //儲存連線過的UUID
    var uuidArray: [String] = []
    
    override init() {
        super.init()
        
        //取得連線過的UUID
        if let tUUIDArray = UserDefaults.standard.array(forKey: USERDEFAULTS_UUIDARRAY) as? [String] {
            uuidArray = tUUIDArray
        }
    }
    
    func findUUIDFromUUIDArray(uuid: String) -> Bool {
        return uuidArray.contains(where: { $0 == uuid })
    }
    
    func saveToUUIDArray(uuid: String) {
        if !findUUIDFromUUIDArray(uuid: uuid) {
            uuidArray.append(uuid)
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(uuidArray, forKey: USERDEFAULTS_UUIDARRAY)
            userDefaults.synchronize()
        }
    }
    
    func deleteUUID(uuid: String) {
        uuidArray.removeAll(where: { $0 == uuid })
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(uuidArray, forKey: USERDEFAULTS_UUIDARRAY)
        userDefaults.synchronize()
    }
    
}
