//
//  Login.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/4/30.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func loginGoMore(email: String, pwd: String, completionHandler: @escaping GMSHandler<GMSResponseLogin>) {
        
        let parameters = ["email": email,
                          "pwd": pwd,
                          "social_type": GMSSocialType.gomore.rawValue]
        
        callApi(path: "login/login_gomore.php", method: .post, parameters: parameters, completionHandler: { resultType in
            switch resultType {
            case .success(let result):
                let response = GMSResponseLogin(from: result)
                self.token = response.token ?? ""
                completionHandler(.success(response))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}

