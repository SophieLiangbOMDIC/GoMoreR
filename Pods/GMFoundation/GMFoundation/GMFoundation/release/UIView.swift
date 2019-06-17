//
//  UIView+Tool.swift
//  Extensions
//
//  Created by jake on 2017/5/26.
//  Copyright © 2017年 jake. All rights reserved.
//

import UIKit

public extension UIView {
    
    //取得Blur View
    func blur() -> UIView {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.frame
        
        return visualEffectView
    }
    
    //製作左下 左上 圓角
    func cornerRadiusTLBL(size: Int) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: size, height: size)).cgPath
        self.layer.mask = rectShape
    }
    
    //製作右下 右上 圓角
    func cornerRadiusTRBR(size: Int) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: size, height: size)).cgPath
        self.layer.mask = rectShape
    }
    
    //製作左上 右上 圓角
    func cornerRadiusTop(size: Int) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: size, height: size)).cgPath
        self.layer.mask = rectShape
    }
    
    //動畫旋轉view
    func runSpinAnimation(duration: Double, rotations: Double, repeatCount: Float) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2.0 * rotations * duration
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = repeatCount
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    //漸層
    func gradient(fromColor: UIColor, toColor: UIColor) {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [fromColor.cgColor, toColor.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    //製作圓形
    func circle() {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    //製作陰影
    func shadow(withColor color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 4
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
}
