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
                     (type: .distance, data: String(format: "%.2f", mockData.distance)),
                     (type: .speed, data: String(format: "%.2f", mockData.speed)),
                     (type: .heartRate, data: mockData.heartRate.string + "&" + mockData.zone.string)]
    }
    
    var rows: [(type: CellType, data: String)]
    var mockData: (distance: Double, speed: Double, heartRate: Int, zone: Int) = {
        return (distance: Double.random(in: 1...18),
                speed: Double.random(in: 3...15),
                heartRate: Int.random(in: 60...200),
                zone: Int.random(in: 1...5))
    }()
    
}
