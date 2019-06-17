//
//  RMWorkoutFinal.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/24.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RMWorkoutFinal: Object {
    
    dynamic public var workoutId: Int = 0
    dynamic public var distanceKm: Float = 0.0
    dynamic public var distanceKmMax: Float = 0.0
    dynamic public var hr: Int = 0
    dynamic public var hrZone: Int = 1
    dynamic public var kcal: Float = 0.0
    dynamic public var kcalMax: Float = 0.0
    dynamic public var speed: Double = 0.0
    dynamic public var stamina: Int = 0
    dynamic public var staminaAerobic: Int = 0
    dynamic public var staminaAnaerobic: Int = 0
    dynamic public var timeStart: Date = Date()
    dynamic public var timeEnd: Date = Date()
    dynamic public var timeSeconds: Int = 0
    dynamic public var id: String = UUID().uuidString
    dynamic public var teStamina: Float = 0
    dynamic public var teAer: Float = 0
    dynamic public var teAnaer: Float = 0
    dynamic public var sdkVersion: String = ""
    public let workoutDatas = List<RMWorkoutData>()
    dynamic public var uploadStatus: UploadStatus = .uploadFail
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["workoutId"] = self.workoutId.string
        dict["hr"] = String(self.hr)
        dict["distanceKm"] = self.distanceKm
        dict["distanceKmMax"] = self.distanceKmMax
        dict["kcal"] = self.kcal
        dict["kcalMax"] = self.kcalMax
        dict["speed"] = self.speed
        dict["staminaEnd"] = self.stamina
        dict["staminaAerobic"] = self.staminaAerobic
        dict["staminaAnaerobic"] = self.staminaAnaerobic
        dict["timeStart"] = self.timeStart
        dict["timeSeconds"] = self.timeSeconds
        dict["teStamina"] = self.teStamina
        dict["teAerobic"] = self.teAer
        dict["teAnaerobic"] = self.teAnaer

        return dict
    }
    
}
