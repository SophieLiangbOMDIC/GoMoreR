//
//  UITableViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/13.
//  Copyright © 2019 jake. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let id = String(describing: name)
        var bundle: Bundle? = nil
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: id, bundle: bundle), forCellReuseIdentifier: id)
    }
    
}
