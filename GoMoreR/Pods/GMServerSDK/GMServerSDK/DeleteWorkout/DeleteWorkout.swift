//
//  DeleteWorkout.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func deleteWorkout(userWorkoutId: Int, completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        callApi(path: "workout/delete.php", method: .post, parameters: ["user_workout_id": userWorkoutId]) { (resultType) in
            switch resultType {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
