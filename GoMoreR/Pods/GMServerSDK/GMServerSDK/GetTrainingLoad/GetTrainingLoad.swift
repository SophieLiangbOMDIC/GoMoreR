//
//  GetTrainingLoad.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getTrainingLoad(periodStart: String, periodEnd: String, periodGap: Int, completionHandler: @escaping GMSHandler<[GMSResponseTrainingLoad]>) {
        
        let parameters: [String: Any] = ["period_start": periodStart,
                                         "period_end": periodEnd,
                                         "period_gap": periodGap,
                                         "timezone": Date().timezone()]
        
        callApi(path: "workout/training_load.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                var finalArray: [GMSResponseTrainingLoad] = []
                let data = result["data"] as? [String: Any] ?? [:]
                let trainingLoadArr = data["training_load"] as? [[String: Any]] ?? []
                for trainingLoad in trainingLoadArr {
                    finalArray.append(GMSResponseTrainingLoad(from: trainingLoad))
                }
                completionHandler(.success(finalArray))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
}
