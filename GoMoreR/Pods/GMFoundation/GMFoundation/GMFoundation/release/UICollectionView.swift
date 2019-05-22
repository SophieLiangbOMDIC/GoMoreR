//
//  UICollectionView.swift
//  GMFoundation
//
//  Created by Sophie Liang on 2019/5/21.
//  Copyright © 2019 bOMDIC. All rights reserved.
//

import Foundation

public extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    func register<T: UICollectionViewCell>(nib: UINib?, forCellWitClass name: T.Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let id = String(describing: name)
        var bundle: Bundle? = nil
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: id, bundle: bundle), forCellWithReuseIdentifier: id)
    }
    
}
