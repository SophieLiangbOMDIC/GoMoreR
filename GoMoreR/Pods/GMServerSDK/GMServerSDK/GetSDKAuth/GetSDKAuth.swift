//
//  SDKAuth.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getSdkAuth(userId: String, deviceId: String, completionHandler: @escaping GMSHandler<GMSResponseSDKAuth>) {
        
        let parameters = ["user_id": userId, "device_id": deviceId, "sdk_type": "app"]
        
        callApi(path: "b2b/sdk_auth.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                let response = GMSResponseSDKAuth(from: result)
                completionHandler(.success(response))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    
    
}
