//
//  Extensions.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/4/30.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension String {
    
    public func GMSDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let value = Calendar.current.locale?.currencyCode, value == "JPY" {
            dateFormatter.locale = Locale(identifier: "ja_JP")
        }
        return dateFormatter.date(from: self)
    }
    
    public var GMSInt: Int? {
        return Int(self)
    }
    
    public func GMSDouble(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? Double
    }
    
}

extension Date {
    
    public func string(withFormat format: String = "yyyy-MM-dd HH:mm:ss", locale: String = "en_US_POSIX") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let value = Calendar.current.locale?.currencyCode, value == "JPY" {
            dateFormatter.locale = Locale(identifier: "ja_JP")
        }
        return dateFormatter.string(from: self)
    }
    
    public func timezone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "XXX"
        dateFormatter.timeZone = TimeZone.current
        var timezone = dateFormatter.string(from: Date())
        timezone = timezone.replacingOccurrences(of: ":", with: "")
        return timezone
    }
    
}

extension Double {
    
    public var GMInt: Int? {
        return Int(self)
    }
    
}
