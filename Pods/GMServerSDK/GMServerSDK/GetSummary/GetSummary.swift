//
//  GetSummary.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getSummary(typeId: String, completionHandler: @escaping GMSHandler<(summaryArray: [GMSResponseSummary], hrZoneArray: [GMSResponseHrZone])>) {
        let parameters: [String: Any] = ["type_id": typeId,
                                         "timezone": Date().timezone(),
                                         "unzip": 1]
        callApi(path: "user/summary.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
                
            case .success(let result):
                var hrZoneArray: [GMSResponseHrZone] = []
                let hrZoneDict = result["hrzone_ptc"] as? [String: Double] ?? [:]
                for (key, value) in hrZoneDict {
                    let zone = String(key.last ?? Character("")).GMSInt
                    hrZoneArray.append(GMSResponseHrZone(ptc: value, zone: zone))
                }
                
                var summaryArray: [GMSResponseSummary] = []
                let dataArr = result["data"] as? [[String: Any]] ?? []
                for data in dataArr {
                    summaryArray.append(GMSResponseSummary(from: data))
                }
                completionHandler(.success((summaryArray: summaryArray, hrZoneArray: hrZoneArray)))
                
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
