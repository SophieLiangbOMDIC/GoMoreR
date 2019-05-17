//
//  EditWorkoutComment.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

extension GMSManager {
    
    public func editWorkoutComment(userWorkoutId: Int, title: String, description: String, completionHandler: @escaping GMSHandler<[String: Any]>) {
        
        let parameters: [String: Any] = ["user_workout_id": userWorkoutId,
                                         "comment_title": title,
                                         "comment_description": description]
        callApi(path: "workout/comment_edit.php", method: .post, parameters: parameters) { (resultType) in
            switch resultType {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
