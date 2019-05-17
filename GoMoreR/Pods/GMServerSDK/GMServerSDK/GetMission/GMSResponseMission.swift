//
//  GMSResponseMission.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseMission {
    
    public var missionName: String?
    public var timeStart: Date?
    public var userWorkoutId: Int?
    
    init(from dict: [String: Any]) {
        self.missionName = dict["mission_name"] as? String
        self.timeStart = (dict["time_start"] as? String ?? "").GMSDate()
        self.userWorkoutId = (dict["user_workout_id"] as? String ?? "").GMSInt
    }
}
