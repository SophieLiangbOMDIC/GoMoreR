//
//  GetTrainingStatus.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getTrainingStatus(typeId: String, completionHandler: @escaping GMSHandler<Int?>) {
        
        let parameters = ["type_id": typeId]
        callApi(path: "user/training_status.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                let status = result["training_status"] as? Int
                completionHandler(.success(status))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        
        
    }
    
}
