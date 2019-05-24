//
//  WorkoutViewModel.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import UIKit
import GMFoundation

class WorkoutViewModel {
    
    enum CellType {
        case time
        case distance
        case speed
        case heartRate
        case zone
        
        var title: String {
            switch self {
            case .time: return "時間"
            case .distance: return "距離(km)"
            case .speed: return "速度"
            case .heartRate, .zone: return "心率＆區間"
            }
        }
    }
    
    init() {
        self.rows = [(type: .time, data: "00:00:00"),
                     (type: .distance, data: String(format: "%.2f", self.distance)),
                     (type: .speed, data: String(format: "%.2f", self.speed)),
                     (type: .heartRate, data: self.hr.string + "&" + self.zone.string)]
    }
    
    var rows: [(type: CellType, data: String)]
    var mockData: (distance: Double, speed: Double, heartRate: Int, zone: Int) = {
        return (distance: Double.random(in: 1...18),
                speed: Double.random(in: 3...15),
                heartRate: Int.random(in: 60...200),
                zone: Int.random(in: 1...5))
    }()
    var longitude: Double = -1
    var latitude: Double = -1
    var altitude: Double = -1
    var distance: Float = 0
    var speed: Double = 0
    var hr: Int = 0
    var zone: Int = 1
    
    func updateData() {
        self.rows[1] = (type: .distance, data: String(format: "%.2f", self.distance))
        self.rows[2] = (type: .speed, data: String(format: "%.2f", self.speed))
        self.rows[3] = (type: .heartRate, data: self.hr.string + "&" + self.zone.string)
    }
    
}
