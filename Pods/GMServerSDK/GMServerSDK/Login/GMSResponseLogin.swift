//
//  GMSResponseLogin.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/2.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseLogin {
    
    public var token: String?
    public var userId: String?
    public var resetPwd: Int?
    
    init(from dictionary: [String: Any]) {
        self.token = dictionary["token"] as? String
        self.userId = dictionary["user_id"] as? String
        self.resetPwd = dictionary["reset_pwd"] as? Int
    }
    
}
