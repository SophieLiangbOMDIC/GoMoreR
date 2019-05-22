
//
//  WorkoutViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMBluetoothSDK

class WorkoutViewController: UIViewController {

    @IBAction func tapFinishButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waveView: UIView!
    
    let vm = WorkoutViewModel()
    var timer: Timer!
    var time: Int = 0
    var stamina: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            self.time += 1
            let data = self.time.hhmmss()
            self.vm.rows[0] = (type: .time, data: data)
            self.tableView.reloadData()
            
//            self.stamina -= 0.005
//            if let wave = self.waveView.subviews[0] as? WaveView {
//                let height = self.waveView.frame.height * self.stamina
//                wave.frame = CGRect(x: 0,
//                                    y: self.waveView.frame.height - height,
//                                    width: self.waveView.frame.width,
//                                    height: height)
//            }
        }
        
        let height = waveView.frame.height * stamina
        let wave = WaveView(frame: CGRect(x: 0,
                                          y: waveView.frame.height - height,
                                          width: waveView.frame.width,
                                          height: height))
        wave.waveCurvature = 3
        waveView.addSubview(wave)
        
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
    
    func managerPowerOff() {
        
    }
    
    func hrConnected(btsdkHr: GMBTHr) {

    }
    
    func cadenceConnected(btsdkCadence: GMBTCadence) {

    }
    
    func powerConnected(btsdkPower: GMBTPower) {

    }
    
    func hrDisconnect() {
        
    }
    
    func cadenceDisconnect() {
        
    }
    
    func powerDisconnect() {
        
    }
    
    func sensorInfo() {
        
    }
    
    func sensorHr(hr: Int) {
        self.vm.rows[3] = (type: .heartRate, data: hr.string)
        tableView.reloadData()
    }
    
    func sensorCadence(cadence: Int) {
        
    }
    
    func sensorPower(power: Int) {
        
    }
    
}
