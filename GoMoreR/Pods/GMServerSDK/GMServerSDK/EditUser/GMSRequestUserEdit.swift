//
//  GMSRequestUserEdit.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSRequestUserEdit {
    
    public var email: String?
    public var userName: String = ""
    public var birthday: String = ""
    public var unit: String = ""
    public var heightCm: Double = 0.0
    public var weightKg: Double = 0.0
    public var gender: String = ""
    public var countryCode: String = ""
    public var avatarData: Data?
    
    public init(email: String?, userName: String, birthday: String, unit: String, heightCm: Double, weightKg: Double, gender: GMSGender, countryCode: String, avatarData: Data?) {
        self.email = email
        self.userName = userName
        self.birthday = birthday
        self.unit = unit
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.gender = gender.rawValue
        self.countryCode = countryCode
        self.avatarData = avatarData
    }
    
    func toDict() -> [String: String] {
        
        var dict: [String: String] = [:]
        if let email = email {
            dict["email"] = email
        }
        dict["user_name"] = userName
        dict["birthday"] = birthday
        dict["unit"] = unit
        dict["height_cm"] = String(heightCm)
        dict["weight_kg"] = String(weightKg)
        dict["gender"] = gender
        dict["country_code"] = countryCode
        
        return dict
        
    }
    
}
