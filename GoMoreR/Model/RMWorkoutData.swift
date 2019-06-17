//
//  RMWorkout.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/24.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RMWorkoutData: Object {
    
    dynamic public var longitude: Double = 0.0
    dynamic public var latitude: Double = 0.0
    dynamic public var altitude: Double = 0.0
    dynamic public var distanceKm: Float = 0.0
    dynamic public var hr: Int = 0
    dynamic public var hrZone: Int = 1
    dynamic public var kcal: Float = 0.0
    dynamic public var speed: Double = 0.0
    dynamic public var stamina: Int = 0
    dynamic public var staminaAerobic: Int = 0
    dynamic public var staminaAnaerobic: Int = 0
    dynamic public var timeDate: Date = Date()
    dynamic public var seconds: Int = 0
    dynamic public var id: String = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["sec"] = String(self.seconds)
        dict["hr"] = String(self.hr)
        dict["pr"] = "0"
        dict["ca"] = "0"
        dict["td"] = self.timeDate.string(withFormat: "yyyyMMddHHmmss")
        dict["dist"] = String(self.distanceKm)
        dict["sp"] = String(self.speed)
        dict["al"] = String(self.latitude)
        dict["lo"] = String(self.longitude)
        dict["la"] = String(self.latitude)
        dict["inc"] = "0"
        return dict
    }
}
