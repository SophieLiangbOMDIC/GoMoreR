//
//  UserEdit.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation
import Alamofire

extension GMSManager {
    
    public func editUser(requestData: GMSRequestUserEdit, completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        // check network
        guard NetworkReachabilityManager()!.isReachable else {
            completionHandler(.failure(.noInternet))
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let date = Date().string(withFormat: "yyyyMMddhhmmss")
            if let avatarData = requestData.avatarData {
                multipartFormData.append(avatarData, withName: "file_avatar", fileName: date, mimeType: "image/png")
            }
            multipartFormData.append(self.clientSecret.data(using: .utf8) ?? Data(), withName: "client_secret")
            multipartFormData.append(self.clientId.data(using: .utf8) ?? Data(), withName: "client_id")
            multipartFormData.append(self.token.data(using: .utf8) ?? Data(), withName: "token")
            
            for (key, value) in requestData.toDict() {
                multipartFormData.append(value.data(using: .utf8) ?? Data(), withName: key)
            }
            
        }, to: self.api + "user/edit.php", encodingCompletion: { (result) in
            switch result {
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    switch response.result {
                        
                    case .success(let result):
                        let result = result as? [String: Any] ?? [:]
                        let status = result["status"] as? String ?? ""
                        if status == "0" {
                            let fileAvatar = result["file_avatar"] as? String ?? ""
                            completionHandler(.success(["fileAvatar": fileAvatar]))
                        } else {
                            completionHandler(.failure(.statusError(code: Int(status) ?? -1)))
                        }
                    case .failure( _):
                        completionHandler(.failure(.noData))
                    }
                })
            case .failure( _):
                completionHandler(.failure(.noData))
            }
            
        })
        
    }
    
}
