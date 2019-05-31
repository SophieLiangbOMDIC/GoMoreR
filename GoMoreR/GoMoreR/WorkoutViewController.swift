
//
//  WorkoutViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waveView: UIView!
    @IBAction func tapButton(_ sender: UIButton) {
        sender.isEnabled = false
        vm.timer.suspend()
        let title: String = sender == finishButton ? "結束運動並上傳？" : "將不記錄此筆資料，\n並離開此頁"
        self.showAlert(title: title, message: nil, buttonTitles: ["取消", "確定"], highlightedButtonIndex: 0) { [weak self] (index) in
            guard let self = self else { return }
            self.vm.timer.resume()
            
            guard index != 0 else {
                sender.isEnabled = true
                return
            }
            
            self.vm.stop()
            
            if sender == self.finishButton {
                self.vm.upload {
                    GMKitManager.kit.stopSession()
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else if sender == self.backButton {
                GMKitManager.kit.stopSession()
                try! RealmManager.realm.write {
                    RealmManager.realm.delete(self.vm.workoutFinal)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    let vm = WorkoutViewModel()
    
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
        
        self.vm.updateUIInTimer = {
            self.staminaLabel.text = String(format: "%02d", Int(self.vm.stamina)) + "%"
            if let wave = self.waveView.subviews[0] as? WaveView {
                let height = self.waveView.frame.height * CGFloat(self.vm.stamina / 100)
                wave.frame = CGRect(x: 0,
                                    y: self.waveView.frame.height - height,
                                    width: self.waveView.frame.width,
                                    height: height)
            }
            self.tableView.reloadData()
        }
        
        self.vm.timerResume()
        self.vm.startAcc()
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
