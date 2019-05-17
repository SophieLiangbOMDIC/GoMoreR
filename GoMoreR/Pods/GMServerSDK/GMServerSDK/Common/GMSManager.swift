//
//  GMSManager.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/4/30.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation
import Alamofire

public class GMSManager: NSObject {
    
    public init(platform: GMSPlatform, showLog: Bool) {
        self.platform = platform
        self.api = platform.api
        self.apiWorkout = platform.apiWorkout
        self.isShowLog = showLog
    }
    
    var platform: GMSPlatform = .develop
    var isShowLog: Bool = true
    var api: String = ""
    var apiWorkout: String = ""
    var clientId: String = "10001"
    var clientSecret: String = "96e79218965eb72c92a549dd5a330112"
    var token: String = ""
    
    public func getApiInfo() -> (api: String, clientId: String, clientSecret: String) {
        return (api: api, clientId: clientId, clientSecret: clientSecret)
    }
    
    func callApi(path: String, item: [String: Any]? = nil, method: HTTPMethod, parameters: [String: Any], completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        // check network
        guard NetworkReachabilityManager()!.isReachable else {
            completionHandler(.failure(.noInternet))
            return
        }
        
        // set url
        let urlString = generateURL(path: path, item: item)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlFailed))
            return
        }
        
        // set http method
        var request = Alamofire.NSMutableURLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60) as URLRequest
        request.httpMethod = method.rawValue
        
        // set http body
        var parameters = parameters
        parameters["client_id"] = clientId
        parameters["client_secret"] = clientSecret
        parameters["token"] = token
    
        // call api
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any] else {
                completionHandler(.failure(.jsonTypeError))

                if self.isShowLog { print(request.url?.absoluteString ?? "", response.error as Any) }
                return
            }
            
            if self.isShowLog { print(request.url?.absoluteString ?? "", response.result) }
            
            let status = result["status"] as? String ?? ""
            if status == "0" {
                completionHandler(.success(result))
            
            } else {
                completionHandler(.failure(.statusError(code: Int(status) ?? -1)))
            }
        }
    }
    
    func download(url: URL, completionHandler: @escaping GMSHandler<URL>) {
        
        let destination = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(url, to: destination).responseData { (response) in
            if let fileUrl = response.destinationURL {
                completionHandler(.success(fileUrl))
            } else {
                completionHandler(.failure(.urlFailed))
            }
        }
    }
    
    private func generateURL(path: String, item: [String: Any]? = nil) -> String {
        
        let urlString: String = api + path
        
        if let item = item {
            var queryItem: [URLQueryItem] = []
            for (key, value) in item {
                queryItem.append(URLQueryItem(name: key, value: "\(value)"))
            }
            
            let urlComponents = NSURLComponents(string: urlString)!
            urlComponents.queryItems = queryItem
            
            return urlComponents.url!.absoluteString
            
        } else {
            return urlString
        }
    }
}
