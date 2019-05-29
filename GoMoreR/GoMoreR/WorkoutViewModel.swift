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
import CoreLocation

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
    var distance: Float = 0
    var speed: Double = 0
    var hr: Int = 0
    var zone: Int = 1
    var workoutId: Int = 0
    var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    func updateData() {
        self.rows[1] = (type: .distance, data: String(format: "%.2f", self.distance))
        self.rows[2] = (type: .speed, data: String(format: "%.2f", self.speed))
        self.rows[3] = (type: .heartRate, data: self.hr.string + "&" + self.zone.string)
    }
    
}
