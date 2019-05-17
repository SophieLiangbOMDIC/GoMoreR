//
//  Login.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func login(socialType: GMSSocialType, socialId: String, countryCode: String, completionHandler: @escaping GMSHandler<GMSResponseLogin>) {
        
        let parameters = ["social_id": socialId,
                          "social_type": socialType.rawValue,
                          "country_code": countryCode]
        
        callApi(path: "login/login.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                let responseLogin = GMSResponseLogin(from: result)
                self.token = responseLogin.token ?? ""
                completionHandler(.success(responseLogin))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    
    
}
