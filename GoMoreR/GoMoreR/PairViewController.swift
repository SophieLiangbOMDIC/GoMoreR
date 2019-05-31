//
//  PairViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMBluetoothSDK
import GMServerSDK

class PairViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func tapCancelButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.minY - 50, width: self.tableView.frame.width, height: self.tableView.frame.height)
        }, completion: { [weak self] finished in
            guard let self = self,
                  let parent = self.parent as? LiteViewController else { return }
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: 0,
                                              y: parent.view.frame.height,
                                              width: self.tableView.frame.width,
                                              height: self.tableView.frame.height)
            }, completion: { finished in
                self.view.removeFromSuperview()
                self.removeFromParent()
                parent.closeBlur()
            })
        })
    }
    var selectedSensor: GMBTSensor!
    var isFromStartButton: Bool = false
    var workoutData: GMSResponseWorkoutInit!
    var userData: GMSResponseUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.tableView.reloadData()
        }
        
        if isFromStartButton, BTManager.shared.bt.hrArray.contains(where: { $0.state == .connected }) {
            self.close()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHr), name: .hrUpdate, object: nil)
    }
    
    func getSensorArr(index: Int) -> [GMBTSensor] {
        let type = GMBTSensorType(rawValue: index) ?? .hr
        switch type {
        case .hr:
            return BTManager.shared.bt.hrArray
        case .cadence:
            return BTManager.shared.bt.cadenceArray
        case .power:
            return BTManager.shared.bt.powerArray
        }
    }
    
    func close() {
        self.tapCancelButton(UIButton())
        self.performSegue(withIdentifier: "PairToWorkout", sender: nil)
        NotificationCenter.default.removeObserver(self, name: .hrUpdate, object: nil)
    }
    
    @objc func updateHr(_ notification: Notification) {
        guard self.isFromStartButton else { return }
        let userInfo = notification.userInfo ?? [:]
        let hr = userInfo["hr"] as? Int ?? 0
        if hr > 0 {
            DispatchQueue.main.async {
                self.showAlert(title: "已連上藍芽裝置", message: "") { index in
                    self.close()
                }
            }
            
        } else {
            DispatchQueue.main.async {
                self.showAlert(title: "無法取得心率", message: "")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WorkoutViewController {
            guard let lastWorkout = RealmManager.realm.objects(RMWorkoutFinal.self).last else { return }
            let second = (Date().timeIntervalSince1970 - lastWorkout.timeEnd.timeIntervalSince1970)
            let _ = GMKitManager.shared.initUser(userData: self.userData,
                                                 workoutData: self.workoutData,
                                                 second: second)
        }
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
                BTManager.shared.bt.connect(sensor: sensor, type: type)
                cell.connectButton.setTitle("連線中", for: .normal)
            } else {
                BTManager.shared.bt.disconnect(sensor: sensor)
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
