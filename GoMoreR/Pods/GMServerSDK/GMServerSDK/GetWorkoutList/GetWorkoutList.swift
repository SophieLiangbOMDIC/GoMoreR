//
//  GetWorkoutList.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getWorkoutList(requestData: GMSRequestWorkoutList, completionHandler: @escaping GMSHandler<(totalRows: Int, pages: Int, data: [GMSResponseWorkout])>) {
        
        callApi(path: "workout/workout_list.php", method: .post, parameters: requestData.toDict()) { (resultType) in
            switch resultType {
            case .success(let result):
                let totalRows = result["total_row"] as? Int ?? 0
                let pages = result["pages"] as? Int ?? 0
                
                var finalData: [GMSResponseWorkout] = []
                let datas = result["data"] as? [[String: Any]] ?? []
                for data in datas {
                    finalData.append(GMSResponseWorkout(from: data))
                }
                completionHandler(.success((totalRows: totalRows, pages: pages, data: finalData)))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
