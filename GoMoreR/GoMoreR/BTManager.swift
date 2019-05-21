//
//  BTManager.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/20.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import GMBluetoothSDK

class BTManager {
    
    static let shared = GMBTManager(isScanGoMore: false, isPairOne: true)
    
}
