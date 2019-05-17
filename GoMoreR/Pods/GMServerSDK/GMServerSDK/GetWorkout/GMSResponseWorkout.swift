//
//  GMSResponseWorkoutData.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseWorkout {
    
    public var appVersion: String?
    public var commentDescription: String?
    public var commentTitle: String?
    public var distanceKm: Double?
    public var distanceKmMax: Double?
    
    public var hrZoneArray: [GMSResponseHrZone] = []
    
    public var fileRouteHROriginal: String?
    public var fileRouteHRVerified: String?
    public var fileRouteHRVerifiedLite: String?
    
    public var awardArray: [GMSResponseAward] = []
    public var mapsArray: [GMSResponseMap] = []
    
    public var filePaceKm: String?
    public var filePaceMile: String?
    public var fileGeoIncline: String?
    public var flagCalc: Int?
    
    public var geoElevationGain: Double?
    public var geoInclineAvg: Double?
    public var geoInclineMax: Double?
    public var heartrateAvg: Int?
    public var heartrateMax: Int?
    public var heartrateMin: Int?
    public var kcal: Double?
    public var kcalMax: Double?
    public var missionName: String?
    public var missionStatus: Int?
    public var paceAvg: Double?
    public var paceAvgMile: Double?
    public var paceMax: Double?
    public var paceMaxMile: Double?
    public var powerAvg: Double?
    public var powerMax: Double?
    public var powerZoneArray: [GMSResponsePower] = []
    public var powerZoneValidTag: Int?
    
    public var questionBreath: String?
    public var questionMuscle: String?
    public var questionRpe: String?
    
    public var speedAvg: Double?
    public var speedAvgMile: Double?
    public var speedMax: Double?
    public var speedMaxMile: Double?
    
    public var staminaAerobicEnd: Int?
    public var staminaAerobicMaxUse: Int?
    public var staminaAnaerobicEnd: Int?
    public var staminaAnaerobicMaxUse: Int?
    public var staminaStart: Int?
    public var staminaEnd: Int?
    public var staminaLevel: Double?
    public var staminaMaxUse: Int?
    
    public var timeEnd: Date?
    public var timeSeconds: Int?
    public var timeSecondsRecovery: Int?
    public var timeStart: Date?
    
    public var typeId: GMSTypeId?
    public var userWorkoutId: Int?
    
    public var sensorTypes: [GMSSensorType] = []
    
    public var teStamina: Double?
    public var teAerobic: Double?
    public var teAnaerobic: Double?
    public var teTarget: String?
    
    public var lthr2: Double?
    public var vo2max: Double?

    public var aerobicLevel: Double?
    public var anaerobicLevel: Double?
    public var workoutStatus: String?
    public var trimp: Int?
    public var ftpPower: Int?
    
    init(from dict: [String: Any]) {
        
        self.userWorkoutId = (dict["user_workout_id"] as? String)?.GMSInt
        self.typeId = GMSTypeId(rawValue: dict["type_id"] as? String ?? "")
        self.flagCalc = (dict["flag_calc"] as? String)?.GMSInt
        self.timeStart = (dict["time_start"] as? String ?? "").GMSDate()
        self.timeEnd = (dict["time_end"] as? String ?? "").GMSDate()
        self.timeSeconds = (dict["time_seconds"] as? String)?.GMSInt
        self.timeSecondsRecovery = (dict["time_seconds_recovery"] as? String)?.GMSInt
        self.teTarget = dict["target_training_effect"] as? String
        self.staminaLevel = (dict["stamina_level"] as? String)?.GMSDouble()
        self.aerobicLevel = (dict["aerobic_level"] as? String)?.GMSDouble()
        self.anaerobicLevel = (dict["anaerobic_level"] as? String)?.GMSDouble()
        self.commentTitle = dict["comment_title"] as? String
        self.commentDescription = dict["comment_description"] as? String
        self.heartrateAvg = (dict["heartrate_avg"] as? String)?.GMSInt
        self.heartrateMax = (dict["heartrate_max"] as? String)?.GMSInt
        self.heartrateMin = (dict["heartrate_min"] as? String)?.GMSInt
        self.fileRouteHROriginal = dict["file_Route_HR_original"] as? String
        self.fileRouteHRVerified = dict["file_Route_HR_verified"] as? String
        self.fileRouteHRVerifiedLite = dict["file_Route_HR_verified_lite"] as? String
        self.staminaMaxUse = (dict["stamina_max_use"] as? String)?.GMSInt
        self.staminaAerobicMaxUse = (dict["stamina_aerobic_max_use"] as? String)?.GMSInt
        self.staminaAnaerobicMaxUse = (dict["stamina_anaerobic_max_use"] as? String)?.GMSInt
        self.staminaStart = (dict["stamina_start"] as? String)?.GMSInt
        self.staminaEnd = (dict["stamina_end"] as? String)?.GMSInt
        self.staminaAerobicEnd = (dict["stamina_aerobic_end"] as? String)?.GMSInt
        self.staminaAnaerobicEnd = (dict["stamina_anaerobic_end"] as? String)?.GMSInt
        self.kcal = (dict["kcal"] as? String)?.GMSDouble()
        self.kcalMax = (dict["kcal_max"] as? String)?.GMSDouble()
        self.distanceKm = (dict["distance_km"] as? String)?.GMSDouble()
        self.distanceKmMax = (dict["distance_km_max"] as? String)?.GMSDouble()
        self.filePaceMile = dict["file_pace_mile"] as? String
        self.filePaceKm = dict["file_pace_km"] as? String
        self.questionRpe = dict["question_rpe"] as? String
        self.questionBreath = dict["question_breath"] as? String
        self.questionMuscle = dict["question_muscle"] as? String
        self.appVersion = dict["app_version"] as? String
        self.workoutStatus = dict["workout_status"] as? String
        self.paceAvg = (dict["pace_avg"] as? String)?.GMSDouble()
        self.paceMax = (dict["pace_max"] as? String)?.GMSDouble()
        self.paceAvgMile = (dict["pace_avg_mile"] as? String)?.GMSDouble()
        self.paceMaxMile = (dict["pace_max_mile"] as? String)?.GMSDouble()
        self.geoInclineAvg = (dict["geo_incline_avg"] as? String)?.GMSDouble()
        self.geoInclineMax = (dict["geo_incline_max"] as? String)?.GMSDouble()
        self.geoElevationGain = (dict["geo_elevation_gain"] as? String)?.GMSDouble()
        self.fileGeoIncline = dict["file_geo_incline"] as? String
        self.missionStatus = (dict["mission_status"] as? String)?.GMSInt
        self.speedAvg = (dict["speed_avg_kmh"] as? String)?.GMSDouble()
        self.speedMax = (dict["speed_max_kmh"] as? String)?.GMSDouble()
        self.speedAvgMile = (dict["speed_avg_mile"] as? String)?.GMSDouble()
        self.speedMaxMile = (dict["speed_max_mile"] as? String)?.GMSDouble()
        self.powerAvg = (dict["power_avg"] as? String)?.GMSDouble()
        self.powerMax = (dict["power_max"] as? String)?.GMSDouble()
        self.trimp = (dict["trimp"] as? String)?.GMSInt
        self.ftpPower = (dict["ftp_power"] as? String)?.GMSInt
        self.vo2max = (dict["vo2max"] as? String)?.GMSDouble()
        self.teAerobic = (dict["training_effect_aerobic"] as? String)?.GMSDouble()
        self.teStamina = (dict["training_effect_stamina"] as? String)?.GMSDouble()
        self.teAnaerobic = (dict["training_effect_anaerobic"] as? String)?.GMSDouble()
        self.lthr2 = (dict["lactate_threshold_heartrate_2"] as? String)?.GMSDouble()
        self.missionName = dict["mission_name"] as? String
        
        self.powerZoneArray = []
        let powerZones = dict["power_zone_sec"] as? [String: Any] ?? [:]
        for (key, value) in powerZones {
            let value = value as? [String: Any] ?? [:]
            self.powerZoneArray.append(GMSResponsePower(from: value, zone: key))
        }

        self.mapsArray = []
        let maps = dict["file_maps"] as? [[String: Any]] ?? []
        for map in maps {
            self.mapsArray.append(GMSResponseMap(from: map))
        }
        
        self.awardArray = []
        let awardArr = dict["file_award"] as? [[String: Any]] ?? []
        for award in awardArr {
            self.awardArray.append(GMSResponseAward(from: award))
        }
        
        self.hrZoneArray = []
        let zoneObject = dict["file_HRZone"] as? [String: Any] ?? [:]
        for (key, value) in zoneObject {
            let value = value as? [String: Any] ?? [:]
            self.hrZoneArray.append(GMSResponseHrZone(from: value, zone: key))
        }
        
        self.sensorTypes = []
        let sensorArr = dict["workout_sensor"] as? [[String: Any]] ?? []
        for sensor in sensorArr {
            let type = sensor["sensor_type"] as? String ?? ""
            self.sensorTypes.append(GMSSensorType(rawValue: type) ?? .heartRate)
        }
    }
}


