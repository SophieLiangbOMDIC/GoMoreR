//
//  Int.swift
//  GMFoundation
//
//  Created by JakeChang on 2019/5/6.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

public extension Int {
    
    //數字轉成碼表字串 hh:mm:ss
    func hhmmss() -> String {
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        if self >= 3600 {
            hours = self / 3600
            minutes = (self / 60) - (hours * 60)
            seconds = self % 60
        }
        else if self >= 60 {
            minutes = self / 60
            seconds = self % 60
        }
        else {
            seconds = self
        }
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    //秒數小於一分鐘秀60秒
    func seconds() -> Int {
        if self > 0 && self <= 60 {
            return 60
        }
        else {
            return self
        }
    }
    
    //秒數小於一分鐘秀1分鐘
    func secsToMins() -> Int {
        let s = self % 60
        if s > 0 {
            return Int(self / 60) + 1
        }
        else {
            return Int(self)
        }
    }
    
    var string: String {
        return String(describing: self)
    }

}
