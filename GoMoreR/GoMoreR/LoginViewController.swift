//
//  ViewController.swift
//  GoMoreR
//
//  Created by JakeChang on 2019/5/10.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 20
        backView.layer.shadowColor = UIColor(red: 174, green: 183, blue: 226)?.cgColor
        backView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backView.layer.shadowOpacity = 1
        accountTextField.layer.cornerRadius = 16
        passwordTextField.layer.cornerRadius = 16
        loginButton.layer.cornerRadius = 25

    }

    @IBAction func clickLoginButton(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withClass: LiteViewController.self) {
//        if let controller = storyboard?.instantiateViewController(withClass: MainViewController.self) {
            present(controller, animated: true, completion: nil)
        }
    }
    
}
