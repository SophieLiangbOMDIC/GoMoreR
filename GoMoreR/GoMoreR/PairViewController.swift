//
//  PairViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMBluetoothSDK

class PairViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func tapCancelButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.minY - 50, width: self.tableView.frame.width, height: self.tableView.frame.height)
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            let parent = self.parent as! LiteViewController
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: 0, y: parent.view.frame.height, width: self.tableView.frame.width, height: self.tableView.frame.height)
            }, completion: { finished in
                self.view.removeFromSuperview()
                self.removeFromParent()
                parent.closeBlur()
            })
        })
    }
    var selectedSensor: GMBTSensor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        BTManager.shared.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.tableView.reloadData()
        }
    }
    
    func getSensorArr(index: Int) -> [GMBTSensor] {
        let type = GMBTSensorType(rawValue: index) ?? .hr
        switch type {
        case .hr:
            return BTManager.shared.hrArray
        case .cadence:
            return BTManager.shared.cadenceArray
        case .power:
            return BTManager.shared.powerArray
        }
    }
    
    func close() {
        self.tapCancelButton(UIButton())
        let parent = self.parent as! LiteViewController
        parent.performSegue(withIdentifier: "LiteToWorkout", sender: nil)
    }
}

extension PairViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSensorArr(index: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PairTableViewCell.self, for: indexPath)
        guard indexPath.row < tableView.numberOfRows(inSection: indexPath.section),
              indexPath.row < getSensorArr(index: indexPath.section).count else { return UITableViewCell() }
        let sensor = getSensorArr(index: indexPath.section)[indexPath.row]
        cell.nameLabel.text = sensor.name ?? ""
        cell.tapConnectButton = {
            let type = GMBTSensorType(rawValue: indexPath.section) ?? .hr
            if sensor.state == .disconnect {
                BTManager.shared.connect(sensor: sensor, type: type)
                cell.connectButton.setTitle("連線中", for: .normal)
            } else {
                BTManager.shared.disconnect(sensor: sensor)
                cell.connectButton.setTitle("斷線中", for: .normal)
            }
        }
        switch sensor.state {
        case .disconnect:
            cell.connectButton.setTitle("連線", for: .normal)
        case .connecting:
            cell.connectButton.setTitle("連線中", for: .normal)
        case .connected:
            cell.connectButton.setTitle("已連線", for: .normal)
        case .reconnect:
            break
        }
        
        return cell
    }
    
}

extension PairViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "心率"
        case 1: return "功率計"
        case 2: return "頻踏器"
        default: return nil
        }
    }
    
}

extension PairViewController: GMBTManagerDelegate {
    
    func managerPowerOff() {
        
    }
    
    func hrConnected(btsdkHr: GMBTHr) {
        close()
    }
    
    func cadenceConnected(btsdkCadence: GMBTCadence) {
        close()
    }
    
    func powerConnected(btsdkPower: GMBTPower) {
        close()
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
        
    }
    
    func sensorCadence(cadence: Int) {
        
    }
    
    func sensorPower(power: Int) {
        
    }
    
}
