//
//  LiteViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMServerSDK
import GoMoreKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: logout
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        self.showAlert(title: "登出後會清除所有資料，確定登出？", message: nil, buttonTitles: ["取消", "確定"], highlightedButtonIndex: 0) { (index) in
            guard index != 0 else { return }
            try! RealmManager.realm.write {
                RealmManager.realm.deleteAll()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: pair bluetooth
    @IBAction func tapBTButton(_ sender: UIButton) {
        tapStartButton(sender)
    }
    
    // MARK: start workout should go to pair page first
    @IBAction func tapStartButton(_ sender: UIButton) {
        sender.isEnabled = false
        BTManager.shared.bt.scan(type: [.hr, .cadence, .power]) { [weak self] (isPowerOn) in
            guard let self = self else { return sender.isEnabled = true }
            if isPowerOn {
                DispatchQueue.main.async {
                    
                    sender.isEnabled = true
                    
                    if let vc = self.storyboard?.instantiateViewController(withClass: PairViewController.self) {
                        
                        self.showBlur()
                        self.addChild(vc)
                        self.view.addSubview(vc.view)
                        
                        vc.tableView.frame = CGRect(x: 0,
                                                    y: self.view.frame.height,
                                                    width: vc.tableView.frame.width,
                                                    height: vc.tableView.frame.height)
                        vc.isFromStartButton = (sender == self.startButton)
                        vc.userData = self.vm.userData
                        vc.workoutData = self.vm.workoutData
                        
                        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
                            vc.tableView.frame = CGRect(x: 0,
                                                        y: self.view.frame.minY,
                                                        width: vc.tableView.frame.width,
                                                        height: vc.tableView.frame.height)
                        }, completion: { finished in
                        })
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    self.showAlert(title: "請開啟藍芽", message: nil)
                }
            }
        }
        
    }
    
    var blurView: UIView!
    let vm = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        blurView = UIView(frame: view.frame)
        blurView = blurView?.blur()
        
        let finalData = RealmManager.realm.objects(RMWorkoutFinal.self)
        print(finalData)
        
        vm.getStamina { [weak self] (stamina) in
            guard let self = self else { return }
            self.staminaLabel.text = String(stamina.split(separator: ".").first ?? "100") + "%"
            self.userNameLabel.text = self.vm.userData.userName ?? "bOMDIC"
        }
        
        vm.checkAndUpload()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.getWorkoutList { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
    }
    
    func showBlur() {
        if let blur = blurView {
            blur.alpha = 0
            view.addSubview(blur)
            UIView.animate(withDuration: 0.3, animations: {
                blur.alpha = 1
            })
        }
    }
    
    func closeBlur() {
        if let blur = blurView {
            UIView.animate(withDuration: 0.3, animations: {
                blur.alpha = 0
            }, completion: { finished in
                blur.removeFromSuperview()
            })
        }
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RecordTableViewCell.self, for: indexPath)
        let thisData = vm.data[indexPath.row]
        cell.setLabel(data: thisData)
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

