//
//  Register.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func register(email: String, pwd: String, countryCode: String, socialType: GMSSocialType, completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        let parameters = ["email": email,
                          "pwd": pwd,
                          "country_code": countryCode,
                          "social_type": socialType.rawValue]
        
        callApi(path: "login/register.php", method: .post, parameters: parameters) { (resultType) in
            completionHandler(resultType)
        }
    }
    
    
}
