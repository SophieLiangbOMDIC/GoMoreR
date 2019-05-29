
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
            ServerManager.sdk.calculateWorkout(userWorkoutId: self.vm.workoutId, completionHandler: { (resultType) in
                
                GMKitManager.kit.stopSession()
                
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
                switch resultType {
                case .success(let status):
                    print(status)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
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
    let realm = try! Realm()
    
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
        
        let workoutDatas = realm.objects(RMWorkoutData.self)
        try! realm.write {
            realm.delete(workoutDatas)
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

            // MARK: update distance
            self.vm.distance = GMKitManager.kit.updateRoute(currentDateTime: Date().timeIntervalSince1970.GMInt ?? 0,
                                                            timerSec: self.time,
                                                            longitude: self.vm.location.coordinate.longitude,
                                                            latitude: self.vm.location.coordinate.latitude,
                                                            altitude: Float(self.vm.location.altitude))
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
                try! self.realm.write {
                    self.realm.add(workoutData)
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
        var dataArray: [[String: Any]] = []
        
        let workoutDataArr = realm.objects(RMWorkoutData.self).sorted(byKeyPath: "seconds")
        for workoutData in workoutDataArr {
            dataArray.append(workoutData.toDict())
        }
        let dataJson = (try? JSONSerialization.data(withJSONObject: dataArray, options: .prettyPrinted)) ?? Data()
        let dataJsonString = String(data: dataJson, encoding: .utf8) ?? ""
        
        let requestData = GMSRequestWorkout(typeId: .run,
                                            timeStart: Date(),
                                            timeSeconds: self.time,
                                            timeSecondsRecovery: 0,
                                            kcal: GMKitManager.kit.kcal() < 0 ? 0 : Int(GMKitManager.kit.kcal()),
                                            kcalMax: 0,
                                            distanceKm: self.vm.distance,
                                            distanceKmMax: self.vm.distance,
                                            questionBreath: GMSBreath.easy,
                                            questionMuscle: GMSMuscle.fine,
                                            questionRpe: GMSRpe.easy,
                                            appVersion: "0.1.0",
                                            missionName: GMSMissionName.calBasic,
                                            missionStatus: GMSMissionStatus.success,
                                            teStamina: GMKitManager.kit.teStamina(),
                                            teAer: GMKitManager.kit.teAerobic(),
                                            teAnaer: GMKitManager.kit.teAnaerobic(),
                                            sdkVersion: GMKitManager.kit.version(),
                                            weatherJson: "",
                                            dataJson: dataJsonString,
                                            debugJson: "")
        ServerManager.sdk.uploadWorkout(requestData: requestData) { (resultType) in
            switch resultType {
            case .success(let workoutId):
                print(workoutId)
                self.vm.workoutId = workoutId.int ?? 0
                
            case .failure(let error):
                print(error)
            }
            completionHandler()
        }
    }
    
    func startAcc() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self else { return }
            
            let x = -(data?.acceleration.x ?? 0) * 10
            let y = -(data?.acceleration.y ?? 0) * 10
            let z = -(data?.acceleration.z ?? 0) * 10
            
            // MARK: update distance and speed
            let array = GMKitManager.kit.updateRouteFusion(longitude: Float(self.vm.location.coordinate.longitude),
                                                           latitude: Float(self.vm.location.coordinate.latitude),
                                                           altitude: Float(self.vm.location.altitude),
                                                           accuracyHorizon: Float(self.vm.location.horizontalAccuracy),
                                                           accuracyVertical: Float(self.vm.location.verticalAccuracy),
                                                           accX: Float(x),
                                                           accY: Float(y),
                                                           accZ: Float(z))
            
            guard array.count >= 2 else { return }
            if let distanceStr = array[0] as? String,
                let distance = distanceStr.double(),
                distance >= 0 {
                self.vm.distance = Float(distance)
            }
            
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
