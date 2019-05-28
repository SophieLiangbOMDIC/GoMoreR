//
//  UploadWorkout.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation
import Alamofire
import Zip

extension GMSManager {
    
    public func uploadWorkout(requestData: GMSRequestWorkout, completionHandler: @escaping GMSHandler<String>) {
        
        // check network
        guard NetworkReachabilityManager()!.isReachable else {
            completionHandler(.failure(.noInternet))
            return
        }
                
        let weatherFilePath = NSTemporaryDirectory() + "file_weather"
        try? requestData.weatherJson.write(toFile: weatherFilePath, atomically: true, encoding: .utf8)
        
        let dataFilePath = NSTemporaryDirectory() + "file_data"
        try? requestData.dataJson.write(toFile: dataFilePath, atomically: true, encoding: .utf8)
        
        let debugFilePath = NSTemporaryDirectory() + "file_debug"
        try? requestData.debugJson.write(toFile: debugFilePath, atomically: true, encoding: .utf8)
        
        let zipUrl = try? Zip.quickZipFiles([URL(string: weatherFilePath)!, URL(string: dataFilePath)!, URL(string: debugFilePath)!], fileName: "file_zip")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let url = zipUrl {
                multipartFormData.append(url, withName: "file_zip", fileName: "file_zip", mimeType: "application/zip")
            }
            
            for (key, value) in requestData.toDict() {
                multipartFormData.append(value.data(using: .utf8) ?? Data(), withName: key)
            }
            
            multipartFormData.append(self.clientSecret.data(using: .utf8) ?? Data(), withName: "client_secret")
            multipartFormData.append(self.clientId.data(using: .utf8) ?? Data(), withName: "client_id")
            multipartFormData.append(self.token.data(using: .utf8) ?? Data(), withName: "token")
            
        }, to: self.api + "workout/upload.php") { (result) in
            switch result {
                
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let result):
                        let result = result as? [String: Any] ?? [:]
                        let status = result["status"] as? String ?? ""
                        if status == "0" {
                            let workoutId = result["user_workout_id"] as? String ?? ""
                            completionHandler(.success(workoutId))
                        } else {
                            completionHandler(.failure(.statusError(code: Int(status) ?? -1)))
                        }
                     case .failure(_):
                        completionHandler(.failure(.noData))
                    }
                })
            case .failure(_):
                completionHandler(.failure(.noData))
            }
        }
    }
    
}
