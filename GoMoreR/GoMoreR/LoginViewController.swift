//
//  ViewController.swift
//  GoMoreR
//
//  Created by JakeChang on 2019/5/10.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GoMoreKit
import GMServerSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var platformTextField: UITextField!
    
    var platforms: [GMSPlatform] = [.develop, .develop_cn, .production, .sandbox_cn]
    var selectedPlatform: GMSPlatform = .develop
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 20
        backView.layer.shadowColor = UIColor(red: 174, green: 183, blue: 226)?.cgColor
        backView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backView.layer.shadowOpacity = 1
        accountTextField.layer.cornerRadius = 16
        passwordTextField.layer.cornerRadius = 16
        loginButton.layer.cornerRadius = 25
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
//        accountTextField.text = "chris.luo+474@bomdic.com"
//        passwordTextField.text = "111111"
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        platformTextField.inputView = pickerView
        
        if let account = UserDefaults.standard.string(forKey: UserDefaultsKey.account.rawValue),
            let password = UserDefaults.standard.string(forKey: UserDefaultsKey.password.rawValue),
            let platform = UserDefaults.standard.string(forKey: UserDefaultsKey.platform.rawValue) {
            platformTextField.text = platform
            accountTextField.text = account
            passwordTextField.text = password
            login(platform: platform, account: account, password: password) {
                guard let controller = self.storyboard?.instantiateViewController(withClass: LiteViewController.self) else { return }
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

    @IBAction func clickLoginButton(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withClass: LiteViewController.self),
            let account = accountTextField.text,
            let password = passwordTextField.text {
            self.login(platform: selectedPlatform.rawValue, account: account, password: password) {
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
        
    func login(platform: String, account: String, password: String, completionHandler: @escaping () -> Void) {
        ServerManager.sdk = GMSManager(platform: GMSPlatform(rawValue: platform) ?? .develop, showLog: true)
        ServerManager.sdk.loginGoMore(email: account, pwd: password) { (resultType) in
            switch resultType {
            case .success(let data):
                ServerManager.sdk.getSdkAuth(userId: data.userId ?? "", deviceId: "AAAAAAAA", completionHandler: { (resultType) in
                    switch resultType {
                    case .success(let data):
                        UserDefaults.standard.set(data.attribute, forKey: UserDefaultsKey.attribute.rawValue)
                        UserDefaults.standard.set(data.secretKey, forKey: UserDefaultsKey.secretKey.rawValue)
                        UserDefaults.standard.set(account, forKey: UserDefaultsKey.account.rawValue)
                        UserDefaults.standard.set(password, forKey: UserDefaultsKey.password.rawValue)
                        UserDefaults.standard.set(self.selectedPlatform.rawValue, forKey: UserDefaultsKey.platform.rawValue)
                        UserDefaults.standard.synchronize()
                        
                        self.errorLabel.text = "登入成功"
                        completionHandler()
                        
                    case .failure(let error):
                        print("getSdkAuth fail \(error)")
                    }
                })
                
            case .failure(let error):
                print("login fail \(error)")
                self.errorLabel.text = "\(error)"
            }
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension LoginViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return platforms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return platforms[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        platformTextField.text = platforms[row].rawValue
        selectedPlatform = platforms[row]
        self.view.endEditing(true)
    }
    
    
}
