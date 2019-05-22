//
//  Date.swift
//  GMFoundation
//
//  Created by JakeChang on 2019/5/6.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

import Foundation

public extension Date {
    
    //Date Format
    func string(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format // "yyyy-MM-dd"
        
        if let value = Calendar.current.locale?.currencyCode, value == "JPY" {
            dateFormatter.locale = Locale(identifier: "ja_JP")
        }
        
        return dateFormatter.string(from: self)
    }
    
    //計算年齡
    func age() -> Int {
        let dateNow = Date()
        let yearThis = Int(dateNow.string(withFormat: "yyyy")) ?? 0
        let yearBirthday = Int(self.string(withFormat: "yyyy")) ?? 0
        let monthDayThis = Int(dateNow.string(withFormat: "MMdd")) ?? 0
        let monthDayBirthday = Int(self.string(withFormat: "MMdd")) ?? 0
        
        var age = 0
        if monthDayBirthday > monthDayThis {
            age = yearThis - yearBirthday - 1
        }
        else {
            age = yearThis - yearBirthday
        }
        
        return age
    }
    
    //取得時區
    func timezone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "XXX"
        dateFormatter.timeZone = NSTimeZone.local
        var timezone = dateFormatter.string(from: self)
        timezone = timezone.replacingOccurrences(of: ":", with: "")
        
        return timezone
    }
    
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
}
