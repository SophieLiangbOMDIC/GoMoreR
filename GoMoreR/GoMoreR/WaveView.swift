//
//  WaveView.swift
//  Wave
//
//  Created by Sophie Liang on 2019/5/9.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import UIKit

class WaveView: UIView {

    var waveCurvature: CGFloat = 5
    var waveSpeed: CGFloat = 0.5
    var waveHeight: CGFloat = 7
    var maskLayer = CAShapeLayer()
    var waveLayer = CAShapeLayer()
    var displayLink = CADisplayLink()
    var offsetX: CGFloat = 0
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    
    func initial() {
        maskLayer.frame = self.bounds
        maskLayer.fillColor = UIColor(red: 235, green: 196, blue: 254)?.cgColor
        
        waveLayer.frame = self.bounds
        waveLayer.fillColor = UIColor(red: 128, green: 117, blue: 255)?.cgColor
        
        self.backgroundColor = .clear
        self.layer.addSublayer(maskLayer)
        self.layer.addSublayer(waveLayer)
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(wave))
        self.displayLink.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc func wave() {
        
        self.offsetX += self.waveSpeed
        let wavePath = CGMutablePath()
        wavePath.move(to: CGPoint(x: 0, y: self.waveHeight))
        
        let maskPath = CGMutablePath()
        maskPath.move(to: CGPoint(x: 0, y: self.waveHeight))
        
        let wave = Float(waveCurvature * 0.01)
        let offset = Float(offsetX * 0.05)
        let maskOffset = Float(offsetX * 0.02)
        
        for x in 0...Int(self.frame.width) {
            let y = waveHeight * CGFloat(sinf(wave * Float(x) + offset))
            wavePath.addLine(to: CGPoint(x: CGFloat(x), y: y))
            
            let maskY = waveHeight * CGFloat(sinf(wave * Float(x) + maskOffset))
            maskPath.addLine(to: CGPoint(x: CGFloat(x), y: maskY))
        }
        
        maskPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height + waveHeight))
        maskPath.addLine(to: CGPoint(x: 0, y: self.bounds.height + waveHeight))
        maskPath.closeSubpath()
        self.maskLayer.path = maskPath
        
        wavePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height + waveHeight))
        wavePath.addLine(to: CGPoint(x: 0, y: self.bounds.height + waveHeight))
        wavePath.closeSubpath()
        self.waveLayer.path = wavePath
       
    }
}
