//
//  ViewController.swift
//  GoMoreR
//
//  Created by JakeChang on 2019/5/10.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GoMoreKit

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
        
        accountTextField.text = "chris.luo+474@bomdic.com"
        passwordTextField.text = "111111"

    }

    @IBAction func clickLoginButton(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withClass: LiteViewController.self) {
            if let account = accountTextField.text, let password = passwordTextField.text {
                ServerManager.sdk.loginGoMore(email: account, pwd: password) { (resultType) in
                    switch resultType {
                    case .success(let data):
                        ServerManager.sdk.getSdkAuth(userId: data.userId ?? "", deviceId: "AAAAAAAA", completionHandler: { (resultType) in
                            switch resultType {
                            case .success(let data):
                                UserDefaults.standard.set(data.attribute, forKey: UserDefaultsKey.attribute.rawValue)
                                UserDefaults.standard.set(data.secretKey, forKey: UserDefaultsKey.secretKey.rawValue)
                                UserDefaults.standard.synchronize()
                                
                                self.present(controller, animated: true, completion: nil)
                                
                            case .failure(let error):
                                print("getSdkAuth fail \(error)")
                            }
                        })

                    case .failure(let error):
                        print("login fail \(error)")
                    }
                }
            }
//        if let controller = storyboard?.instantiateViewController(withClass: MainViewController.self) {
//            present(controller, animated: true, completion: nil)
        }
    }
    
}
