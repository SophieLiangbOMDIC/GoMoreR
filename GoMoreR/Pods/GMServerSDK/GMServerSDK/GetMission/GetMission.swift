//
//  GetMission.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getMission(typeId: String, completionHandler: @escaping GMSHandler<[GMSResponseMission]>) {
        
        let parameters = ["type_id": typeId]
        callApi(path: "workout/mission.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                var finalData: [GMSResponseMission] = []
                let dataArr = result["data"] as? [[String: Any]] ?? []
                for data in dataArr {
                    finalData.append(GMSResponseMission(from: data))
                }
                completionHandler(.success(finalData))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
}
