//
//  GMKitManager.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/24.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import GoMoreKit
import GMServerSDK
import GMFoundation

class GMKitManager {
    
    static let shared = GMKitManager()
    static let kit = GMKitStaminaS()
    
    public func initUser(userData: GMSResponseUser, workoutData: GMSResponseWorkoutInit, second: Double = 0) -> Int {
        let secretKey = UserDefaults.standard.string(forKey: UserDefaultsKey.secretKey.rawValue)
        let attribute = UserDefaults.standard.string(forKey: UserDefaultsKey.attribute.rawValue)
        _ = GMKitStaminaS().sdkInit(pKey: secretKey ?? "",
                                    attribute: attribute ?? "",
                                    deviceId: "AAAAAAAA",
                                    currentDateTime: Int(Date().timeIntervalSince1970))
        
        return GMKitManager.kit.initUser(age: (userData.birthday ?? Date()).age(),
                                         gender: userData.gender == "male" ? 1: 0,
                                         heightCm: userData.heightCm ?? 0,
                                         weightKg: userData.weightKg ?? 0,
                                         hrMax: userData.heartRateMax[0].heartRateMax ?? 0,
                                         hrRest: userData.restingHeartRate ?? 0,
                                         aerobicPtc: Float(workoutData.prevAerobicPtc ?? 100.0),
                                         anaerobicPtc: Float(workoutData.prevAnaerobicPtc ?? 100.0),
                                         staminaLevel: Float(workoutData.workoutInitDetail.filter { $0.typeId == .run }.first?.staminaLevel ?? 0.0),
                                         teAerobic: 0,
                                         teAnaerobic: 0,
                                         teStamina: 0,
                                         kcal: 0,
                                         distance: 0,
                                         elapsedSecond: Int(second),
                                         checkSum: workoutData.workoutInitDetail.filter { $0.typeId == .run }.first?.checksum ?? "",
                                         sportType: 31)
    }
}
