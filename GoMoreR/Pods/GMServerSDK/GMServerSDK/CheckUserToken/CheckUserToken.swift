//
//  CheckToken.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func checkUserToken(token: String, appProvider: String, appVersion: String, completionHandler: @escaping GMSHandler<GMSResponseCheckToken>) {
        
        self.token = token
        let parameters = ["app_provider": appProvider, "app_version": appVersion]
        callApi(path: "login/check_user_token.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                let response = GMSResponseCheckToken(from: result)
                self.token = response.token ?? ""
                completionHandler(.success(response))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
