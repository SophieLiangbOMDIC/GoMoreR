//
//  String.swift
//  GMFoundation
//
//  Created by JakeChang on 2019/5/6.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

public extension String {
    
    //取得國家代碼
    static var countryCode: String? {
        let currentLocale = NSLocale.current
        let countryCode = currentLocale.regionCode
        
        return countryCode
    }
    
    //轉Date
    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
    
    //判斷該字串的總高度
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    //判斷該字串的總長度
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    //XibName 轉成 UIView
    func xib(withXibName name: String) -> UIView? {
        guard let array = Bundle.main.loadNibNamed(name, owner: self, options: nil) else {
            return nil
        }
       
        if let view = array[0] as? UIView {
            return view
        }
        else {
            return nil
        }
    }
    
    var int: Int? {
        return Int(self)
    }
    
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? Double
    }
}
