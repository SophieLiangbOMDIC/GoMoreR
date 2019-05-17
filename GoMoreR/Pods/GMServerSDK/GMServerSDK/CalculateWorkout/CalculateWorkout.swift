//
//  CalculateWorkout.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func calculateWorkout(userWorkoutId: Int, completionHandler: @escaping GMSHandler<[String: String]>) {
        
        let parameters: [String: Any] = ["user_workout_id": userWorkoutId]
        callApi(path: "workout/calculate.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                let result = result as? [String: String] ?? ["status": ""]
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
