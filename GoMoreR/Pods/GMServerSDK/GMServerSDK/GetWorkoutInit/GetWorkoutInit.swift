//
//  GetWorkoutInitail.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getWorkoutInit(typeId: String, completionHandler: @escaping GMSHandler<GMSResponseWorkoutInit>) {
        let parameters = ["type_id": typeId]
        callApi(path: "user/init_workout.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                let data = GMSResponseWorkoutInit(from: result)
                completionHandler(.success(data))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
}
