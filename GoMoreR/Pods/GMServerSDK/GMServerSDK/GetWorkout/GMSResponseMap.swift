//
//  GMSResponseMap.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseMap {
    
    public var width: Int?
    public var height: Int?
    public var path: String?
    
    init(from dict: [String: Any]) {
        self.width = (dict["width"] as? String ?? "-1").GMSInt
        self.height = (dict["height"] as? String ?? "-1").GMSInt
        self.path = dict["path"] as? String
    }
}
