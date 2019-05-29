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

class LiteViewController: UIViewController {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSettingButton(_ sender: UIButton) {
    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        BTManager.shared.scan(type: [.hr, .cadence, .power]) { [weak self] (isPowerOn) in
            guard let self = self else { return }
            if isPowerOn {
                DispatchQueue.main.async {
                    self.showBlur()
                    
                    if let vc = self.storyboard?.instantiateViewController(withClass: PairViewController.self) {
                        
                        self.addChild(vc)
                        self.view.addSubview(vc.view)
                        
                        vc.tableView.frame = CGRect(x: 0,
                                                    y: self.view.frame.height,
                                                    width: vc.tableView.frame.width,
                                                    height: vc.tableView.frame.height)
                        
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
                    self.showAlert(title: "請開啟藍芽", message: nil)
                }
            }
        }
        
    }
    
    var data: [GMSResponseWorkout] = []
    var blurView: UIView!
    var workoutData: GMSResponseWorkoutInit!
    var userData: GMSResponseUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        blurView = UIView(frame: view.frame)
        blurView = blurView?.blur()
        
        let finalData = RealmManager.realm.objects(RMWorkoutFinal.self)
        print(finalData)
        
        ServerManager.sdk.getWorkoutInit(typeId: "run") { (resultType) in
            switch resultType {
            case .success(let workout):
                self.workoutData = workout
                ServerManager.sdk.getUser { (resultType) in
                    switch resultType {
                    case .success(let data):
                        self.userData = data
                        let _ = GMKitManager.shared.initUser(userData: data, workoutData: workout)
                        let percentageArr = GMKitManager.kit.getPercentageAfterRecovery(
                            aerobicPtc: Float(workout.prevAerobicPtc ?? 100.0),
                            anaerobicPtc: Float(workout.prevAnaerobicPtc ?? 100.0),
                            elapsedSecond: 0)
                        let stamina = percentageArr[0] as? String ?? "100.0"
                        self.staminaLabel.text = String(stamina.split(separator: ".").first ?? "100") + "%"
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        UploadManager.shared.checkAndUpload()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        ServerManager.sdk.getWorkoutList(requestData: GMSRequestWorkoutList(typeId: .run, page: 1, pageNum: 10, dateStart: nil, dateEnd: nil, flagCalc: nil)) { (resultType) in
            switch resultType {
            case .success( _, _, let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
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

extension LiteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RecordTableViewCell.self, for: indexPath)
        let thisData = data[indexPath.row]
        cell.setLabel(distance: thisData.distanceKm ?? 0.0,
                      time: thisData.timeSeconds ?? 0,
                      date: thisData.timeStart ?? Date(),
                      stamina: CGFloat(Double(thisData.staminaEnd ?? 0) / 100.00),
                      workoutId: thisData.userWorkoutId?.string ?? "")

        return cell
    }
    
}

extension LiteViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

