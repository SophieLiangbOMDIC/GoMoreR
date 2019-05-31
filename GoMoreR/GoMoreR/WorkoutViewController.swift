
//
//  WorkoutViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMBluetoothSDK
import RealmSwift
import GMServerSDK

class WorkoutViewController: UIViewController {

    @IBAction func tapBackButton(_ sender: Any) {
        self.showAlert(title: "將不記錄此筆資料，\n並離開此頁", message: nil, buttonTitles: ["取消", "確定"], highlightedButtonIndex: 0) { (index) in
            guard index != 0 else { return }
            self.vm.motionManager.stopAccelerometerUpdates()
            self.stop()
            GMKitManager.kit.stopSession()
            try! RealmManager.realm.write {
                RealmManager.realm.delete(self.vm.workoutFinal)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapFinishButton(_ sender: UIButton) {
        sender.isEnabled = false
        timer.suspend()
        self.showAlert(title: "結束運動並上傳？", message: nil, buttonTitles: ["取消", "確定"], highlightedButtonIndex: 0) { [weak self] (index) in
            guard let self = self else { return }
            self.timer.resume()
            
            guard index != 0 else {
                sender.isEnabled = true
                return
            }
            
            self.vm.motionManager.stopAccelerometerUpdates()
            self.stop()
            self.vm.upload {
                GMKitManager.kit.stopSession()
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waveView: UIView!
    
    let vm = WorkoutViewModel()
    var timer: DispatchSourceTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        // MARK: set waveView
        let height = waveView.frame.height * CGFloat(self.vm.stamina)
        let wave = WaveView(frame: CGRect(x: 0,
                                          y: waveView.frame.height - height,
                                          width: waveView.frame.width,
                                          height: height))
        wave.waveCurvature = 3
        waveView.addSubview(wave)
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            let _ = GMKitManager.kit.updateHr(currentDateTime: Date().timeIntervalSince1970.GMInt ?? 0,
                                              timerSec: self.vm.time,
                                              hrRaw: self.vm.hr,
                                              speed: self.vm.speed == 0 ? -1 : Float(self.vm.speed),
                                              cyclingCadence: -1,
                                              cyclingPower: -1)
            
            // MARK: update time
            self.vm.time += 1
            let data = self.vm.time.hhmmss()
            self.vm.rows[0] = (type: .time, data: data)

            print(self.vm.time)
            
            // MARK: update zone
            self.vm.zone = GMKitManager.kit.hrZone(hrRaw: self.vm.hr)

            // MARK: update stamina
            self.vm.stamina = GMKitManager.kit.stamina()
            
            self.vm.updateData()
            
            DispatchQueue.main.async {
                self.staminaLabel.text = String(format: "%02d", Int(self.vm.stamina)) + "%"
                if let wave = self.waveView.subviews[0] as? WaveView {
                    let height = self.waveView.frame.height * CGFloat(self.vm.stamina / 100)
                    wave.frame = CGRect(x: 0,
                                        y: self.waveView.frame.height - height,
                                        width: self.waveView.frame.width,
                                        height: height)
                }
                self.tableView.reloadData()
                
                // MARK: save workout data into DB every second
                guard self.vm.hr > 0 else { return }
                let workoutData = RMWorkoutData()
                workoutData.timeDate = Date()
                workoutData.seconds = self.vm.time
                workoutData.hr = self.vm.hr
                workoutData.hrZone = self.vm.zone
                workoutData.kcal = GMKitManager.kit.kcal()
                workoutData.latitude = self.vm.location.coordinate.latitude
                workoutData.longitude = self.vm.location.coordinate.longitude
                workoutData.altitude = self.vm.location.altitude
                workoutData.speed = self.vm.speed
                workoutData.distanceKm = self.vm.distance
                try! RealmManager.realm.write {
                    self.vm.workoutFinal.workoutDatas.append(workoutData)
                }
            }
        }
        timer.resume()
        
        self.vm.startAcc()
    }
    
    func stop() {
        guard self.timer != nil else { return }
        timer.cancel()
        timer = nil
        self.vm.removeObserver()
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
