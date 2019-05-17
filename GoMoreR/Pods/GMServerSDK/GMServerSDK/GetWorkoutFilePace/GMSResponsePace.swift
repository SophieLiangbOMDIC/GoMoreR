//
//  GMSResponsePace.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/7.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponsePace {
    
    public var distance: Int?
    public var seconds: Int?
    
    init(from dict: [String: Any]) {
        self.distance = dict["distance"] as? Int
        if let seconds = dict["seconds_one_km"] as? Int {
            self.seconds = seconds
        } else if let seconds = dict["seconds_one_mile"] as? Int {
            self.seconds = seconds
        }
    }
    
}
