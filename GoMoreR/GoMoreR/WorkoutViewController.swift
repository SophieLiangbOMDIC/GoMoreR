
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

class WorkoutViewController: UIViewController {

    @IBAction func tapFinishButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waveView: UIView!
    
    let vm = WorkoutViewModel()
    var timer: DispatchSourceTimer!
    var time: Int = 0
    var stamina: Float = 1
    let locationManager = CLLocationManager()
    let workoutData = RMWorkoutData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        BTManager.shared.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let height = waveView.frame.height * CGFloat(stamina)
        let wave = WaveView(frame: CGRect(x: 0,
                                          y: waveView.frame.height - height,
                                          width: waveView.frame.width,
                                          height: height))
        wave.waveCurvature = 3
        waveView.addSubview(wave)
        
        let realm = try! Realm()
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            let _ = GMKitManager.shared.updateHr(currentDateTime: Date().timeIntervalSince1970.GMInt ?? 0,
                                                 timerSec: self.time,
                                                 hrRaw: self.vm.hr,
                                                 speed: -1,
                                                 cyclingCadence: -1,
                                                 cyclingPower: -1)
            
            // MARK: update time
            self.time += 1
            let data = self.time.hhmmss()
            self.vm.rows[0] = (type: .time, data: data)

            // MARK: update distance
            self.vm.distance = GMKitManager.shared.updateRoute(currentDateTime: Date().timeIntervalSince1970.GMInt ?? 0,
                                                               timerSec: self.time,
                                                               longitude: self.vm.longitude,
                                                               latitude: self.vm.latitude,
                                                               altitude: Float(self.vm.altitude))
            print(self.time)
            
            // MARK: update zone
            self.vm.zone = GMKitManager.shared.hrZone(hrRaw: self.vm.hr)

            // MARK: update stamina
            self.stamina = GMKitManager.shared.stamina()
            
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
                
                let workoutData = RMWorkoutData()
                workoutData.timeDate = Date()
                workoutData.seconds = self.time
                workoutData.hr = self.vm.hr
                workoutData.hrZone = self.vm.zone
                workoutData.kcal = GMKitManager.shared.kcal()
                workoutData.latitude = self.vm.latitude
                workoutData.longtitude = self.vm.longitude
                try! realm.write {
                    realm.add(workoutData)
                }

            }
        }
        timer.resume()
    }
    
    func stopTimer() {
        timer.cancel()
        timer = nil
    }
    
    deinit {
        timer.setEventHandler { }
        timer.cancel()
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
    
    func managerPowerOff() { }
    func hrConnected(btsdkHr: GMBTHr) { }
    func cadenceConnected(btsdkCadence: GMBTCadence) { }
    func powerConnected(btsdkPower: GMBTPower) { }
    func hrDisconnect() { }
    func cadenceDisconnect() { }
    func powerDisconnect() { }
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
        vm.latitude = loc.coordinate.latitude
        vm.longitude = loc.coordinate.longitude
        vm.altitude = loc.altitude
    }
}
