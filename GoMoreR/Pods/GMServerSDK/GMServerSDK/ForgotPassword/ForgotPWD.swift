//
//  ForgotPWD.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func forgorPWD(email: String, pwd: String, completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        let parameters = ["email": email, "pwd": pwd]
        callApi(path: "login/forgot_pwd.php", method: .post, parameters: parameters) { (resultType) in
            completionHandler(resultType)
        }
        
    }
    
}
