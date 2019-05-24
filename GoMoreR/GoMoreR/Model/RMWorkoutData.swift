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
    
    dynamic public var longtitude: Double = 0.0
    dynamic public var latitude: Double = 0.0
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
}
