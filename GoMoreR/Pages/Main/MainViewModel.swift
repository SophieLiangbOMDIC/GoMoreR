//
//  MainViewModel.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/6/17.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import GMServerSDK
import GoMoreKit
import RealmSwift

class MainViewModel {
    
    var data: [GMSResponseWorkout] = []
    var workoutData: GMSResponseWorkoutInit!
    var userData: GMSResponseUser!
    
    func getStamina(completionHandler: @escaping (String) -> Void) {
        // MARK: init sdk and user to get stamina
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
                        completionHandler(stamina)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkAndUpload() {
        
        // MARK: check DB data status
        UploadManager.shared.checkAndUpload()

    }
    
    func getWorkoutList(completionHandler: @escaping () -> Void) {
        ServerManager.sdk.getWorkoutList(requestData: GMSRequestWorkoutList(typeId: .run, page: 1, pageNum: 10, dateStart: nil, dateEnd: nil, flagCalc: nil)) { (resultType) in
            switch resultType {
            case .success( _, _, let data):
                self.data = data
                completionHandler()
                
            case .failure(let error):
                print(error)
                /*let workoutDB = RealmManager.realm.objects(RMWorkoutFinal.self)
                 for workout in workoutDB {
                 if !self.data.contains(where: { (workoutData) -> Bool in
                 workoutData.userWorkoutId == workout.workoutId
                 }) {
                 self.data.insert(GMSResponseWorkout(from: workout.toDict()), at: 0)
                 }
                 }
                 self.tableView.reloadData()*/
            }
        }

    }

}
