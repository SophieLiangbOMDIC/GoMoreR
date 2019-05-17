//
//  GetTrainingSession.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    public func getTrainingSession(completionHandler: @escaping GMSHandler<[GMSResponseTrainingSession]>) {
        
        callApi(path: "workout/training_session.php", method: .post, parameters: [:]) { (resultType) in
            switch resultType {
            case .success(let result):
                var finalArray: [GMSResponseTrainingSession] = []
                let dataArr = result["data"] as? [[String: Any]] ?? []
                for data in dataArr {
                    let workoutType = data["workout_type"] as? String
                    let sessionCourseArr = data["training_session_course"] as? [[String: Any]] ?? []
                    
                    for sessionCourse in sessionCourseArr {
                        let trainingSession = sessionCourse["training_session"] as? String
                        let trainingDetailArr = sessionCourse["training_detail"] as? [[String: Any]] ?? []
                        
                        for trainingDetail in trainingDetailArr {
                            let trainingEffect = trainingDetail["training_effect"] as? String
                            let activateStatus = trainingDetail["activate_status"] as? Int
                            let descriptionArr = trainingDetail["description"] as? [[String: Any]] ?? []
                            
                            for description in descriptionArr {
                                let response = GMSResponseTrainingSession(workoutType: workoutType,
                                                                          activateStatus: activateStatus,
                                                                          trainingSession: trainingSession,
                                                                          trainingEffect: trainingEffect,
                                                                          dict: description)
                                finalArray.append(response)
                            }
                        }
                    }
                }
                completionHandler(.success(finalArray))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}


