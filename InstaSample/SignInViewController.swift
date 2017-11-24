//
//  SignInViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/09.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

class SignInViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(){
        
        if (userIdTextField.text?.characters.count)! <= 0{
            return
        }
        if (passwordTextField.text?.characters.count)! <= 0{
            return
        }
        
        NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error)
            }else{
                //ログイン成功
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "rootTabbarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                //ログイン状態保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
                
            }
            
        }
    }

   
}
