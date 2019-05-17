//
//  GMSResponseHeartRate.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseHeartRateMax {
    
    public var typeId: GMSTypeId?
    public var heartRateMax: Int?

    init(from dictionary: [String: Any]) {
        self.typeId = GMSTypeId(rawValue: dictionary["type_id"] as? String ?? "")
        self.heartRateMax = (dictionary["heartrate_max"] as? String)?.GMSInt
    }
    
}
