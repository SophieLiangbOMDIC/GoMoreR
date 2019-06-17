//
//  GetWorkoutFileData.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation
import Zip

extension GMSManager {
    
    public func getWorkoutFileData(url: URL, completionHandler: @escaping GMSHandler<[GMSResponseFileData]>) {
        
        download(url: url) { (resultType) in
            switch resultType {
            case .success(let resultUrl):
                do {
                    let dataUrl = try Zip.quickUnzipFile(resultUrl).absoluteString
                    let url = dataUrl.replacingOccurrences(of: "file://", with: "")
                    let files = try FileManager.default.contentsOfDirectory(atPath: url)
            
                    var finalData: [GMSResponseFileData] = []
                    for file in files where file == "file_data" {
                        let filePath = url + file
                        let data = FileManager.default.contents(atPath: filePath) ?? Data()
                        let jsonArr = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]] ?? []
                        for json in jsonArr {
                            finalData.append(GMSResponseFileData(from: json))
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
