//
//  UserTypeMaxHrEdit.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func editUserMaxHr(typeId: String, hr: Int, completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        let parameters: [String: Any] = ["type_id": typeId,
                                         "max_heartrate": hr]
        
        callApi(path: "user/max_heartrate.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
}
