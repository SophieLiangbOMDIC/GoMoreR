//
//  GMSResponseSdkAuth.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseSDKAuth {
    
    public var attribute: String?
    public var secretKey: String?
    
    init(from dictionary: [String: Any]) {
        self.attribute = dictionary["sdk_attribute"] as? String
        self.secretKey = dictionary["secret_key"] as? String
    }
}
