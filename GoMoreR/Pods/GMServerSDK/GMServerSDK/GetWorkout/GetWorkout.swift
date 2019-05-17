//
//  GetWorkoutData.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getWorkout(userWorkoutId: Int, completionHandler: @escaping GMSHandler<GMSResponseWorkout>) {
        
        let parameters: [String: Any] = ["user_workout_id": userWorkoutId]
        callApi(path: "workout/workout_data.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                var finalData: GMSResponseWorkout = GMSResponseWorkout(from: [:])
                let data = result["data"] as? [[String: Any]] ?? []
                if data.count > 0 {
                    finalData = GMSResponseWorkout(from: data[0])
                }
                completionHandler(.success(finalData))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
}
