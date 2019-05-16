//
//  Date.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation

extension Date {
    
    public func string(withFormat format: String = "yyyy-MM-dd HH:mm:ss", locale: String = "en_US_POSIX") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
}
