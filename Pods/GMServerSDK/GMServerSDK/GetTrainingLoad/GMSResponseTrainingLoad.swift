//
//  GMSResponseTrainingLoad.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseTrainingLoad {
    
    public var workLoadStamina: Double?
    public var legacyLoadStamina: Double?
    public var time: Date?
    
    init(from dict: [String: Any]) {
        self.workLoadStamina = dict["work_load_stamina"] as? Double
        self.legacyLoadStamina = dict["legacy_load_stamina"] as? Double
        self.time = (dict["time"] as? String ?? "").GMSDate()
    }
}
