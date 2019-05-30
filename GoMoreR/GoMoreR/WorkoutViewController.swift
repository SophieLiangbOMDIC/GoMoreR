
//
//  WorkoutViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMBluetoothSDK
import CoreLocation
import RealmSwift
import GMServerSDK
import CoreMotion

class WorkoutViewController: UIViewController {

    @IBAction func tapBackButton(_ sender: Any) {
        motionManager.stopAccelerometerUpdates()
        self.stopTimer()
        GMKitManager.kit.stopSession()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapFinishButton(_ sender: UIButton) {
        sender.isEnabled = false
        self.stopTimer()
        motionManager.stopAccelerometerUpdates()
        self.upload {
            GMKitManager.kit.stopSession()
            DispatchQueue.main.async {
                sender.isEnabled = true
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waveView: UIView!
    
    let vm = WorkoutViewModel()
    var timer: DispatchSourceTimer!
    var time: Int = 0
    var stamina: Float = 1
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    let workoutFinal = RMWorkoutFinal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        BTManager.shared.delegate = self
        
        // MARK: set location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // MARK: set waveView
        let height = waveView.frame.height * CGFloat(stamina)
        let wave = WaveView(frame: CGRect(x: 0,
                                          y: waveView.frame.height - height,
                                          width: waveView.frame.width,
                                          height: height))
        wave.waveCurvature = 3
        waveView.addSubview(wave)
        
        // MARK: save to realm
        workoutFinal.timeStart = Date()
        let workoutDatas = RealmManager.realm.objects(RMWorkoutData.self)
        try! RealmManager.realm.write {
            RealmManager.realm.add(workoutFinal)
            RealmManager.realm.delete(workoutDatas)
        }
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            let _ = GMKitManager.kit.updateHr(currentDateTime: Date().timeIntervalSince1970.GMInt ?? 0,
                                              timerSec: self.time,
                                              hrRaw: self.vm.hr,
                                              speed: self.vm.speed == 0 ? -1 : Float(self.vm.speed),
                                              cyclingCadence: -1,
                                              cyclingPower: -1)
            
            // MARK: update time
            self.time += 1
            let data = self.time.hhmmss()
            self.vm.rows[0] = (type: .time, data: data)

            print(self.time)
            
            // MARK: update zone
            self.vm.zone = GMKitManager.kit.hrZone(hrRaw: self.vm.hr)

            // MARK: update stamina
            self.stamina = GMKitManager.kit.stamina()
            
            self.vm.updateData()
            DispatchQueue.main.async {
                self.staminaLabel.text = String(format: "%02d", Int(self.stamina)) + "%"
                if let wave = self.waveView.subviews[0] as? WaveView {
                    let height = self.waveView.frame.height * CGFloat(self.stamina / 100)
                    wave.frame = CGRect(x: 0,
                                        y: self.waveView.frame.height - height,
                                        width: self.waveView.frame.width,
                                        height: height)
                }
                self.tableView.reloadData()
                
                guard self.vm.hr > 0 else { return }
                let workoutData = RMWorkoutData()
                workoutData.timeDate = Date()
                workoutData.seconds = self.time
                workoutData.hr = self.vm.hr
                workoutData.hrZone = self.vm.zone
                workoutData.kcal = GMKitManager.kit.kcal()
                workoutData.latitude = self.vm.location.coordinate.latitude
                workoutData.longitude = self.vm.location.coordinate.longitude
                workoutData.altitude = self.vm.location.altitude
                workoutData.speed = self.vm.speed
                workoutData.distanceKm = self.vm.distance
                try! RealmManager.realm.write {
                    self.workoutFinal.workoutDatas.append(workoutData)
                }
            }
        }
        timer.resume()
        
        startAcc()
    }
    
    func stopTimer() {
        guard self.timer != nil else { return }
        timer.cancel()
        timer = nil
    }
    
    func upload(completionHandler: @escaping () -> Void) {
        
        try! RealmManager.realm.write {
            self.workoutFinal.timeEnd = Date()
            self.workoutFinal.timeSeconds = self.time
            self.workoutFinal.distanceKm = self.vm.distance
            self.workoutFinal.speed = self.vm.speed
            self.workoutFinal.stamina = Int(self.stamina)
            self.workoutFinal.hr = self.vm.hr
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
    
    func startAcc() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self else { return }
            
            let x = -(data?.acceleration.x ?? 0) * 10
            let y = -(data?.acceleration.y ?? 0) * 10
            let z = -(data?.acceleration.z ?? 0) * 10
            
            let array = GMKitManager.kit.updateRouteFusion(longitude: Float(self.vm.location.coordinate.longitude),
                                                           latitude: Float(self.vm.location.coordinate.latitude),
                                                           altitude: Float(self.vm.location.altitude),
                                                           accuracyHorizon: Float(self.vm.location.horizontalAccuracy),
                                                           accuracyVertical: Float(self.vm.location.verticalAccuracy),
                                                           accX: Float(x),
                                                           accY: Float(y),
                                                           accZ: Float(z))
            
            guard array.count >= 2 else { return }
            // MARK: update distance
            if let distanceStr = array[0] as? String,
                let distance = distanceStr.double(),
                distance >= 0 {
                self.vm.distance = Float(distance)
            }
            
            // MARK: update speed
            if let speedStr = array[1] as? String,
                let speed = speedStr.double(),
                speed >= 0 {
                self.vm.speed = speed
            }
            
        }
    }
}

extension WorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: WorkoutTableViewCell.self, for: indexPath)
        cell.titleLabel.text = vm.rows[indexPath.row].type.title
        cell.dataLabel.text = vm.rows[indexPath.row].data
        return cell
    }
}

extension WorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4
    }
    
}

extension WorkoutViewController: GMBTManagerDelegate {
    func disconnect(type: GMBTSensorType) { }
    func managerPowerOff() { }
    func hrConnected(btsdkHr: GMBTHr) { }
    func cadenceConnected(btsdkCadence: GMBTCadence) { }
    func powerConnected(btsdkPower: GMBTPower) { }
    func sensorInfo() { }
    
    func sensorHr(hr: Int) {
        self.vm.hr = hr
    }
    
    func sensorCadence(cadence: Int) { }
    func sensorPower(power: Int) { }
}

extension WorkoutViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        vm.location = loc
    }
}
