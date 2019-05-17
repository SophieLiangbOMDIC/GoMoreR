//
//  GMSResponseWorkoutData.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseWorkoutInitDetail {
    
    public var typeId: GMSTypeId?
    public var hrMax: Int?
    public var checksum: String?
    public var staminaLevel: Double?
    public var prevAerobicPtc: Double?
    public var prevAnaerobicPtc: Double?
    
    init(from dict: [String: Any]) {
        self.typeId = GMSTypeId(rawValue: dict["type_id"] as? String ?? "")
        self.hrMax = (dict["heartrate_max"] as? String)?.GMSInt
        self.checksum = dict["checksum"] as? String
        self.staminaLevel = (dict["stamina_level"] as? String)?.GMSDouble()
        self.prevAerobicPtc = (dict["prev_aerobic_ptc"] as? String)?.GMSDouble()
        self.prevAnaerobicPtc = (dict["prev_anaerobic_ptc"] as? String)?.GMSDouble()
    }
    
}
