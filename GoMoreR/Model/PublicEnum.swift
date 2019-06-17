//
//  UserDefaultKey.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/23.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation

struct UserDefaultsKey {
    static let attribute = "attribute"
    static let secretKey = "secretKey"
    static let user = "user"
    static let account = "account"
    static let password = "password"
    static let platform = "platform"
}

@objc enum UploadStatus: Int, Error {
    case uploadFail = 0
    case calculateFail = 1
    case uploaded = 2
}

extension Notification.Name {
    static let hrUpdate = Notification.Name("hrUpdate")
}

func secondsToString(_ seconds : Int) -> String {
    
    let hours = Int(seconds / 3600)
    let minutes = Int(seconds % 3600 / 60)
    let second = Int(seconds - hours * 3600 - minutes * 60)
    
    return String(format: "%02d", hours) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", second)
}
