//
//  GMSResponseTrainingSession.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseTrainingSession {
    
    public var activateStatus: Int?
    public var duration: Int?
    public var hrzone: Int?
    public var index: Int?
    public var speed: Int?
    public var power: Int?
    public var trainingSession: String?
    public var trainingEffect: Double?
    public var type: String?
    public var workoutType: String?
    
    init(workoutType: String?, activateStatus: Int?, trainingSession: String?, trainingEffect: String?, dict: [String: Any]) {
        self.workoutType = workoutType
        self.activateStatus = activateStatus
        self.trainingSession = trainingSession
        self.trainingEffect = (trainingEffect ?? "").GMSDouble()
        self.type = dict["type"] as? String
        self.duration = dict["duration"] as? Int
        self.index = dict["index"] as? Int
        self.power = (dict["power"] as? String ?? "").GMSInt
        self.speed = (dict["speed"] as? String ?? "").GMSInt
        self.hrzone = dict["hrzone"] as? Int
    }
    
}
