//
//  Double.swift
//  GMFoundation
//
//  Created by JakeChang on 2019/5/21.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

import Foundation

public extension Double {
    
    //公里轉英里
    var kmToMile: Double { return self * 0.621371192 }
    
    //速度(m/s)轉配速(/km)
    var speedMSToPaceKm: Double { return 1000 / self }
    
    //速度(m/s)轉配速(/mile)
    var speedMSToPaceMile: Double { return 1609 / self }

    //無條件捨去到小數點第一位
    func floorPointOne() -> Double {
        var t = self * 10
        t = floor(t)
        t = t / 10
        
        return t
    }
    
    var string: String {
        return String(describing: self)
    }
}
