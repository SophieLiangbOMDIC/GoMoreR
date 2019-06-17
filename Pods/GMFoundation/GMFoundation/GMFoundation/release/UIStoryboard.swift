//
//  UIStoryboard.swift
//  GMFoundation
//
//  Created by Sophie Liang on 2019/5/21.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

import Foundation

extension UIStoryboard {
    
    public func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: name)) as! T
    }
}
