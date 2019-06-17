//
//  PublicEnum.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/4/30.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public typealias GMSHandler<T> = (Result<T, GMSFailError>) -> Void

public enum GMSPlatform: String {
    case develop
    case qa
    case staging
    case production
    case urun
    case develop_cn
    case sandbox_cn
    
    var api: String {
        switch self {
        case .develop:
            return "https://rin.bomdic.com/develop/api/"
        case .qa:
            return "https://qa.bomdic.com/develop/api/"
        case .staging:
            return "https://stagingsys.bomdic.com/develop/api/"
        case .production:
            return "https://api.gomore.me/v2/api/"
        case .urun:
            return "https://urun.bomdic.com/v2/api/"
        case .develop_cn:
            return "https://cnsandbox.bomdic.com/develop/api/"
        case .sandbox_cn:
            return "https://cnsandbox.bomdic.com/v2/api/"
        }
    }
    
    var apiWorkout: String {
        switch self {
        case .develop:
            return "https://rin.bomdic.com/develop/workout/"
        case .qa:
            return "https://qa.bomdic.com/develop/workout/"
        case .staging:
            return "https://stagingsys.bomdic.com/develop/workout/"
        case .production:
            return "https://service.gomore.me/v2/workout/"
        case .urun:
            return "https://service.gomore.me/v2/workout/"
        case .develop_cn:
            return "https://cnsandbox.bomdic.com/develop/workout/"
        case .sandbox_cn:
            return "https://cnsandbox.bomdic.com/v2/workout/"
        }
    }
    
    
}

public enum GMSFailError: Error {
    
    case noInternet
    case urlFailed
    case jsonTypeError
    case statusError(code: String)
    case noData
    case uploadFail
    case calculateFail(code: String, workoutId: String)
    
    var errorCode: String {
        switch self {
        case .statusError(let code), .calculateFail(let code, _):
            return code
        default:
            return ""
        }
    }
    
    var workoutId: String {
        switch self {
        case .calculateFail(_, let id):
            return id
        default:
            return ""
        }
    }
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum GMSSocialType: String {
    case gomore
    case facebook
    case twitter
}

public enum GMSGender: String {
    case male
    case female
}

public enum GMSSensorType: String {
    case heartRate = "heartrate"
    case power
    case cadence
}

public enum GMSTypeId: String {
    case run
    case cycle
}

public enum GMSBreath: String {
    case easy = "BREATH_EASY"
    case hard = "BREATH_HARD"
    case veryHard = "BREATH_VERYHARD"
}

public enum GMSMuscle: String {
    case fine = "MUSCLE_FINE"
    case soreness = "MUSCLE_SORENESS"
    case cramp = "MUSCLE_CRAMP"
    case pulledHurt = "MUSCLE_PULLED_HURT"
}

public enum GMSRpe: String {
    case easy = "RPE_L_EASY"
    case hard = "RPE_L_HARD"
    case veryHard = "RPE_L_VERYHARD"
}

public enum GMSMissionStatus: Int {
    case success = 1
    case fail = -1
}

public enum GMSMissionName: String {
    case hrResting = "mission_hr_resting"
    case fifteenKm = "mission_15km"
    case threeKm = "mission_3km"
    case calBasic = "mission_cal_basic"
}
