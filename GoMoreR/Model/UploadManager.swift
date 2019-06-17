//
//  UploadManager.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/29.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import RealmSwift
import GMServerSDK

public class UploadManager {
    
    static let shared = UploadManager()
    
    lazy var workoutFinalDatas: Results<RMWorkoutFinal> = {
        let datas = RealmManager.realm.objects(RMWorkoutFinal.self)
        return datas
    }()
    
    func upload(workoutFinal: RMWorkoutFinal, completionHandler: @escaping (Result<String, GMSFailError>) -> Void) {
        var dataArray: [[String: Any]] = []
        let workoutDataArr = workoutFinal.workoutDatas
        for workoutData in workoutDataArr {
            dataArray.append(workoutData.toDict())
        }
        
        let dataJson = try? JSONSerialization.data(withJSONObject: dataArray, options: .prettyPrinted)
        var dataJsonString = ""
        if let dataJson = dataJson {
            dataJsonString = String(data: dataJson, encoding: .utf8) ?? ""
        } else {
            dataJsonString = String(describing: dataArray)
        }
    
        let requestData = GMSRequestWorkout(typeId: .run,
                                            timeStart: workoutFinal.timeStart,
                                            timeSeconds: workoutFinal.timeSeconds,
                                            timeSecondsRecovery: 0,
                                            kcal: Int(workoutFinal.kcal),
                                            kcalMax: 0,
                                            distanceKm: workoutFinal.distanceKm,
                                            distanceKmMax: workoutFinal.distanceKm,
                                            questionBreath: GMSBreath.easy,
                                            questionMuscle: GMSMuscle.fine,
                                            questionRpe: GMSRpe.easy,
                                            appVersion: "0.1.0",
                                            missionName: GMSMissionName.calBasic,
                                            missionStatus: GMSMissionStatus.success,
                                            teStamina: workoutFinal.teStamina,
                                            teAer: workoutFinal.teAer,
                                            teAnaer: workoutFinal.teAnaer,
                                            sdkVersion: workoutFinal.sdkVersion,
                                            weatherJson: "",
                                            dataJson: dataJsonString,
                                            debugJson: "")
        ServerManager.sdk.uploadWorkout(requestData: requestData) { (resultType) in
            switch resultType {
            case .success(let workoutId):
                completionHandler(.success(workoutId))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func calculate(workoutFinal: RMWorkoutFinal) {
        ServerManager.sdk.calculateWorkout(userWorkoutId: workoutFinal.workoutId, completionHandler: { (resultType) in
            switch resultType {
            case .success(_):
                try! RealmManager.realm.write {
                    workoutFinal.uploadStatus = .uploaded
                }

            case .failure(let error):
                print(error)
                try! RealmManager.realm.write {
                    workoutFinal.uploadStatus = .calculateFail
                }
            }
        })
    }
    
    func checkAndUpload() {
        let workoutFinals = workoutFinalDatas.filter { $0.uploadStatus != .uploaded }.sorted(by: { $0.timeEnd > $1.timeEnd })
        
        for workoutFinal in workoutFinals {
            switch workoutFinal.uploadStatus {
            case .uploadFail:
                self.upload(workoutFinal: workoutFinal, completionHandler: { (resultType) in
                    switch resultType {
                    case .success(let workoutId):
                        try! RealmManager.realm.write {
                            workoutFinal.uploadStatus = .uploaded
                            workoutFinal.workoutId = workoutId.int ?? 0
                        }
                        
                    case .failure(let error):
                        switch error {
                        case .uploadFail:
                            try! RealmManager.realm.write {
                                workoutFinal.uploadStatus = .uploadFail
                            }
                            
                        case .calculateFail(let code, _):
                            print(code, "calculate fail")
                            try! RealmManager.realm.write {
                                workoutFinal.uploadStatus = .calculateFail
                            }
                            
                        default:
                            break
                        }
                    }
                })
                
            case .calculateFail:
                self.calculate(workoutFinal: workoutFinal)
                
            case .uploaded:
                continue
            }
        }
    }
}
