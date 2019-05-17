//
//  GMSResponseWorkoutInit.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseWorkoutInit {
    
    public var prevAerobicPtc: Double?
    public var prevAnaerobicPtc: Double?
    public var workoutInitDetail: [GMSResponseWorkoutInitDetail] = []
    
    init(from dict: [String: Any]) {
        self.prevAerobicPtc = (dict["prev_aerobic_ptc"] as? String)?.GMSDouble()
        self.prevAnaerobicPtc = (dict["prev_anaerobic_ptc"] as? String)?.GMSDouble()
        
        self.workoutInitDetail = []
        let dataArr = dict["data"] as? [[String: Any]] ?? []
        for data in dataArr {
            self.workoutInitDetail.append(GMSResponseWorkoutInitDetail(from: data))
        }
    }
    
}
