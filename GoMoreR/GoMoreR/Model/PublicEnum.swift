//
//  UserDefaultKey.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/23.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
    case attribute
    case secretKey
    case user
}

@objc enum UploadStatus: Int, Error {
    case uploadFail = 0
    case calculateFail = 1
    case uploaded = 2
}
