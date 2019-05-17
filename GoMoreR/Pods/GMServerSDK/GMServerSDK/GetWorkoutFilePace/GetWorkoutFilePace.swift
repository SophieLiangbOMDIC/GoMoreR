//
//  GetWorkoutFilePace.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/7.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation
import Zip

extension GMSManager {
    
    public func getWorkoutFilePace(url: URL, completionHandler: @escaping GMSHandler<[GMSResponsePace]>) {
        
        download(url: url) { (resultType) in
            switch resultType {
            case .success(let resultUrl):
                do {
                    let dataUrl = try Zip.quickUnzipFile(resultUrl).absoluteString
                    let url = dataUrl.replacingOccurrences(of: "file://", with: "")
                    let files = try FileManager.default.contentsOfDirectory(atPath: url)
                    
                    var finalData: [GMSResponsePace] = []
                    for file in files {
                        let filePath = url + file
                        let data = FileManager.default.contents(atPath: filePath) ?? Data()
                        let jsonArr = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]] ?? []
                        
                        for json in jsonArr {
                            finalData.append(GMSResponsePace(from: json))
                        }
                    }
                    completionHandler(.success(finalData))
                    
                } catch {
                    completionHandler(.failure(.noData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
