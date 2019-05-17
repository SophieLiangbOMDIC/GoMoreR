//
//  GMSResponseBestRunningTime.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/7.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseBestRunningTime {
    
    public var distance: String?
    public var timeSeconds: Int?
    public var pace: Double?
    
    init(from dict: [String: Any]) {
        self.distance = dict["distance"] as? String
        self.timeSeconds = dict["timesecond"] as? Int
        self.pace = dict["pace"] as? Double
    }
}
