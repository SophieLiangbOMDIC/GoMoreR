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
import CoreMotion

class WorkoutViewModel: NSObject {
    
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
    
    override init() {
        self.rows = [(type: .time, data: "00:00:00"),
                     (type: .distance, data: String(format: "%.2f", self.distance)),
                     (type: .speed, data: String(format: "%.2f", self.speed)),
                     (type: .heartRate, data: self.hr.string + "&" + self.zone.string)]
        super.init()
        
        // MARK: set location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // MARK: set notification observe
        NotificationCenter.default.addObserver(self, selector: #selector(updateHr), name: .hrUpdate, object: nil)
        
        // MARK: save to realm
        workoutFinal.timeStart = Date()
        let workoutDatas = RealmManager.realm.objects(RMWorkoutData.self)
        try! RealmManager.realm.write {
            RealmManager.realm.add(workoutFinal)
            RealmManager.realm.delete(workoutDatas)
        }

    }
    
    var rows: [(type: CellType, data: String)]
    var stamina: Float = 1
    var distance: Float = 0
    var speed: Double = 0
    var hr: Int = 0
    var zone: Int = 1
    var workoutId: Int = 0
    var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    let workoutFinal = RMWorkoutFinal()
    var time: Int = 0
    var timer: DispatchSourceTimer!
    var updateUIInTimer: (() -> Void)?
    
    func updateData() {
        self.rows[1] = (type: .distance, data: String(format: "%.2f", self.distance))
        self.rows[2] = (type: .speed, data: String(format: "%.2f", self.speed))
        self.rows[3] = (type: .heartRate, data: self.hr.string + "&" + self.zone.string)
    }
    
    func startAcc() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self else { return }
            
            let x = -(data?.acceleration.x ?? 0) * 10
            let y = -(data?.acceleration.y ?? 0) * 10
            let z = -(data?.acceleration.z ?? 0) * 10
            
            let array = GMKitManager.kit.updateRouteFusion(longitude: Float(self.location.coordinate.longitude),
                                                           latitude: Float(self.location.coordinate.latitude),
                                                           altitude: Float(self.location.altitude),
                                                           accuracyHorizon: Float(self.location.horizontalAccuracy),
                                                           accuracyVertical: Float(self.location.verticalAccuracy),
                                                           accX: Float(x),
                                                           accY: Float(y),
                                                           accZ: Float(z))
            
            guard array.count >= 2 else { return }
            // MARK: update distance
            if let distanceStr = array[0] as? String,
                let distance = distanceStr.double(),
                distance >= 0 {
                self.distance = Float(distance)
            }

            // MARK: update speed
            if let speedStr = array[1] as? String,
                let speed = speedStr.double(),
                speed >= 0 {
                self.speed = speed
            }
        }
    }
    
    @objc func updateHr(_ notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        self.hr = (userInfo["hr"] as? Int) ?? 0
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .hrUpdate, object: nil)
    }
    
    func upload(completionHandler: @escaping () -> Void) {
        
        try! RealmManager.realm.write {
            self.workoutFinal.timeEnd = Date()
            self.workoutFinal.timeSeconds = self.time
            self.workoutFinal.distanceKm = self.distance
            self.workoutFinal.speed = self.speed
            self.workoutFinal.stamina = Int(self.stamina)
            self.workoutFinal.hr = self.hr
            self.workoutFinal.kcal = Float(GMKitManager.kit.kcal() < 0 ? 0 : Int(GMKitManager.kit.kcal()))
            self.workoutFinal.teStamina = GMKitManager.kit.teStamina()
            self.workoutFinal.teAer = GMKitManager.kit.teAerobic()
            self.workoutFinal.teAnaer = GMKitManager.kit.teAnaerobic()
            self.workoutFinal.sdkVersion = GMKitManager.kit.version()
        }
        
        UploadManager.shared.upload(workoutFinal: self.workoutFinal) { (resultType) in
            switch resultType {
            case .success(let workoutId):
                print(workoutId)
                try! RealmManager.realm.write {
                    self.workoutFinal.workoutId = workoutId.int ?? 0
                }
                UploadManager.shared.calculate(workoutFinal: self.workoutFinal) {
                    completionHandler()
                }
                
            case .failure(let error):
                print(error)
                try! RealmManager.realm.write {
                    self.workoutFinal.uploadStatus = .uploadFail
                }
                completionHandler()
            }
        }
    }
    
    func timerResume() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            let _ = GMKitManager.kit.updateHr(currentDateTime: Date().timeIntervalSince1970.GMInt ?? 0,
                                              timerSec: self.time,
                                              hrRaw: self.hr,
                                              speed: self.speed == 0 ? -1 : Float(self.speed),
                                              cyclingCadence: -1,
                                              cyclingPower: -1)
            
            // MARK: update time
            self.time += 1
            let data = self.time.hhmmss()
            self.rows[0] = (type: .time, data: data)
            
            print(self.time)
            
            // MARK: update zone
            self.zone = GMKitManager.kit.hrZone(hrRaw: self.hr)
            
            // MARK: update stamina
            self.stamina = GMKitManager.kit.stamina() > 0 ? GMKitManager.kit.stamina() : 100
            
            self.updateData()
            
            DispatchQueue.main.async {
                self.updateUIInTimer?()
            
                // MARK: save workout data into DB every second
                guard self.hr > 0 else { return }
                let workoutData = RMWorkoutData()
                workoutData.timeDate = Date()
                workoutData.seconds = self.time
                workoutData.hr = self.hr
                workoutData.hrZone = self.zone
                workoutData.kcal = GMKitManager.kit.kcal()
                workoutData.latitude = self.location.coordinate.latitude
                workoutData.longitude = self.location.coordinate.longitude
                workoutData.altitude = self.location.altitude
                workoutData.speed = self.speed
                workoutData.distanceKm = self.distance
                try! RealmManager.realm.write {
                    self.workoutFinal.workoutDatas.append(workoutData)
                }
            }
        }
        timer.resume()
    }
    
    func stop() {
        stopAcc()
        stopTimer()
        stopObserver()
    }
    
    func stopAcc() {
        self.motionManager.stopAccelerometerUpdates()
    }
    
    func stopTimer() {
        guard self.timer != nil else { return }
        timer.resume()
        timer.cancel()
        timer = nil
        print("stop")
    }
    
    func stopObserver() {
        self.removeObserver()
    }
}

extension WorkoutViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        self.location = loc
    }
    
}
