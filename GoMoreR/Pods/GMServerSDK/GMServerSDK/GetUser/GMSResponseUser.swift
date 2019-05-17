//
//  GMSResponseUser.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseUser {
    
    public var userName: String?
    public var email: String?
    public var fileAvatar: URL?
    public var birthday: Date?
    public var heightCm: Int?
    public var weightKg: Int?
    public var unit: String?
    public var restingHeartRate: Int?
    public var countryCode: String?
    public var gender: String?
    public var restingHeartRateInit: Bool
    public var heartRateMax: [GMSResponseHeartRateMax] = []
    
    init(from dictionary: [String: Any]) {
        self.userName = dictionary["user_name"] as? String
        self.email = dictionary["email"] as? String
        
        self.gender = dictionary["gender"] as? String
        self.birthday = (dictionary["birthday"] as? String)?.GMSDate(withFormat: "yyyy-MM-dd")
        self.heightCm = (dictionary["height_cm"] as? String)?.GMSInt
        self.countryCode = dictionary["country_code"] as? String
        self.restingHeartRate = (dictionary["resting_heartrate"] as? String)?.GMSInt
        self.restingHeartRateInit = ((dictionary["resting_heartrate_init"] as? String) == "y")
        self.unit = dictionary["unit"] as? String
        self.userName = dictionary["user_name"] as? String
        self.weightKg = (dictionary["weight_kg"] as? String)?.GMSDouble()?.GMInt
    
        let heartRateMaxArr = dictionary["heartrate_max"] as? [[String: Any]] ?? []
        self.heartRateMax = []
        for heartRate in heartRateMaxArr {
            self.heartRateMax.append(GMSResponseHeartRateMax(from: heartRate))
        }
        
        if let fileURL = dictionary["file_avatar"] as? String, let url = URL(string: fileURL) {
            self.fileAvatar = url
        }
    }
    
    
}
