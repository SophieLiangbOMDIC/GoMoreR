//
//  GMSResponseCheckToken.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseCheckToken {
    
    public var days: Int?
    public var sysMsg: String?
    public var token: String?
    public var isOpenSensor: Bool
    
    init(from dictionary: [String: Any]) {
        self.days = dictionary["days"] as? Int
        self.sysMsg = dictionary["sys_msg"] as? String
        self.token = dictionary["token"] as? String
        self.isOpenSensor = ((dictionary["is_open_sensor"] as? String) == "1")
    }
    
}
