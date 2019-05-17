//
//  User.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func getUser(completionHandler: @escaping GMSHandler<GMSResponseUser>) {
        
        callApi(path: "user/user.php", method: .post, parameters: [:]) { (resultType) in
            switch resultType {
                
            case .success(let result):
                let result = result["data"] as? [[String: Any]] ?? []
                if result.count > 0 {
                    let responseUser = GMSResponseUser(from: result[0])
                    completionHandler(.success(responseUser))
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
