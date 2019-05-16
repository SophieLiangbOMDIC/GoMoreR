//
//  SidebarViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController {
    
    @IBOutlet weak var sidebarView: UIView!
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        self.parent?.dismiss(animated: true, completion: nil)
        close()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func close() {
        let parent = self.parent as! MainViewController
        self.view.removeFromSuperview()
        self.removeFromParent()
        parent.closeBlur()
    }
}
