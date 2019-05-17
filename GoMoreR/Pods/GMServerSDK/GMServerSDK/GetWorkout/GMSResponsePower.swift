//
//  GMSResponsePower.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponsePower {
    
    public var powerZone: Int = 0
    public var max: Int?
    public var min: Int?
    public var seconds: Int?
    
    init(from dict: [String: Any], zone: String) {
        self.powerZone = String(zone.last ?? Character("")).GMSInt ?? 0
        self.max = dict["max"] as? Int
        self.min = dict["min"] as? Int
        self.seconds = dict["sec"] as? Int
    }

    
}
