//
//  UIStoryboardExtension.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/13.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: name)) as! T
    }    
}
