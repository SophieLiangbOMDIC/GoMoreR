
//
//  WorkoutViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

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
            self.vm.rows[0] = (type: .time, data: "00:00:\(String(format: "%02d", self.time))")
            self.tableView.reloadData()
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
