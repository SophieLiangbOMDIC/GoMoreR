//
//  GMSResponseAward.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseAward {
    
    public var name: String?
    public var value: Double?
    
    init(from dict: [String: Any]) {
        self.name = dict["name"] as? String
        self.value = (dict["value"] as? String ?? "-1").GMSDouble()
    }
}

