//
//  GMSResquestWorkout.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSRequestWorkout {
    
    public var typeId: GMSTypeId
    public var timeStart: Date
    public var timeSeconds: Int
    public var timeSecondsRecovery: Int
    public var commentTitle: String?
    public var commentDescription: String?
    public var kcal: Int
    public var kcalMax: Int
    public var distanceKm: Float
    public var distanceKmMax: Float
    public var questionBreath: String
    public var questionMuscle: String
    public var questionRpe: String
    public var appVersion: String
    public var missionName: String
    public var missionStatus: Int
    public var missionError: String?
    public var teTarget: String?
    public var teStamina: Float
    public var teAer: Float
    public var teAnaer: Float
    public var sdkVersion: String?
    public var userSensor: String?
    public var weatherJson: String?
    public var dataJson: String?
    public var debugJson: String?
    
    public init(typeId: GMSTypeId, timeStart: Date, timeSeconds: Int, timeSecondsRecovery: Int, commentTitle: String? = nil, commentDescription: String? = nil, kcal: Int, kcalMax: Int, distanceKm: Float, distanceKmMax: Float, questionBreath: GMSBreath, questionMuscle: GMSMuscle, questionRpe: GMSRpe, appVersion: String, missionName: GMSMissionName, missionStatus: GMSMissionStatus, missionError: String? = nil, teTarget: String? = nil, teStamina: Float, teAer: Float, teAnaer: Float, sdkVersion: String? = nil, userSensor: String? = nil, weatherJson: String? = nil, dataJson: String? = nil, debugJson: String? = nil) {
        self.typeId = typeId
        self.timeStart = timeStart
        self.timeSecondsRecovery = timeSecondsRecovery
        self.timeSeconds = timeSeconds
        self.commentTitle = commentTitle
        self.commentDescription = commentDescription
        self.kcal = kcal
        self.kcalMax = kcalMax
        self.distanceKm = distanceKm
        self.distanceKmMax = distanceKmMax
        self.questionBreath = questionBreath.rawValue
        self.questionMuscle = questionMuscle.rawValue
        self.questionRpe = questionRpe.rawValue
        self.appVersion = appVersion
        self.missionName = missionName.rawValue
        self.missionStatus = missionStatus.rawValue
        self.missionError = missionError
        self.teTarget = teTarget
        self.teStamina = teStamina
        self.teAer = teAer
        self.teAnaer = teAnaer
        self.sdkVersion = sdkVersion
        self.userSensor = userSensor
        self.weatherJson = weatherJson
        self.dataJson = dataJson
        self.debugJson = debugJson
    }
    
    func toDict() -> [String: String] {
        
        var postDict: [String: String] = [:]
        postDict["type_id"] = typeId.rawValue
        postDict["time_start"] = timeStart.string()
        postDict["time_seconds"] = String(timeSeconds)
        postDict["time_seconds_recovery"] = String(timeSecondsRecovery)
        
        if let commentTitle = commentTitle {
            postDict["comment_title"] = commentTitle
        }
        if let commentDescription = commentDescription {
            postDict["comment_description"] = commentDescription
        }
        
        postDict["kcal"] = String(kcal)
        postDict["kcal_max"] = String(kcalMax)
        postDict["distance_km"] = String(format: "%.2f", distanceKm)
        postDict["distance_km_max"] = String(format: "%.2f", distanceKmMax)
        postDict["question_breath"] = questionBreath
        postDict["question_muscle"] = questionMuscle
        postDict["question_rpe"] = questionRpe
        postDict["app_version"] = appVersion
        postDict["file_maps"] = "750,572|750,200"
        postDict["mission_name"] = missionName
        postDict["mission_status"] = String(missionStatus)
        
        if let missionError = missionError {
            postDict["mission_error"] = missionError
        }
        
        if let userSensor = userSensor {
            postDict["user_sensor"] = userSensor
        }
        
        if let teTarget = teTarget {
            postDict["target_training_effect"] = teTarget
        }
        
        if let sdkVersion = sdkVersion {
            postDict["sdk_version"] = sdkVersion
        }
        postDict["device_id"] = "AAAAAAAA"
        
        postDict["training_effect_stamina"] = String(teStamina)
        postDict["training_effect_aerobic"] = String(teAer)
        postDict["training_effect_anaerobic"] = String(teAnaer)
        
        return postDict
    }
    
}
