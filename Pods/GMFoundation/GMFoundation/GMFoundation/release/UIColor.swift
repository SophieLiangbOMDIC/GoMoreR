//
//  UIColor.swift
//  GMFoundation
//
//  Created by Sophie Liang on 2019/5/21.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

import Foundation

public extension UIColor {
    
    convenience init?(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var alpha = alpha
        if alpha < 0 { alpha = 0 }
        if alpha > 1 { alpha = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
