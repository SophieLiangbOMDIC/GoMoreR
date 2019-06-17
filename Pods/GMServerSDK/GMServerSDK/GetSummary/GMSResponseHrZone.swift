//
//  GMSResponseHrZone.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseHrZone {
    
    public var ptc: Double?
    public var zone: Int?
    public var hrMax: Int?
    public var hrMin: Int?
    public var seconds: Int?
    
    // use for getSummary
    init(ptc: Double?, zone: Int?, hrMax: Int? = nil, hrMin: Int? = nil, seconds: Int? = nil) {
        self.ptc = ptc
        self.zone = zone
        self.hrMax = hrMax
        self.hrMin = hrMin
        self.seconds = seconds
    }
    
    // use for getWorkoutData
    init(from dict: [String: Any], zone: String) {
        self.zone = String(zone.last ?? Character("")).GMSInt
        self.ptc = (dict["ptc"] as? String)?.GMSDouble()
        self.hrMax = dict["hr_max"] as? Int
        self.hrMin = dict["hr_min"] as? Int
        self.seconds = dict["seconds"] as? Int
    }
}
