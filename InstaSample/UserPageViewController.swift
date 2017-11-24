//
//  UserPageViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/09.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

class UserPageViewController: UIViewController {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDisplayNameLavel : UILabel!
    @IBOutlet var userIntroductionTextView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        if let user = NCMBUser.current() {
            userDisplayNameLavel.text = user.object(forKey: "displayName") as? String
            userIntroductionTextView.text = user.object(forKey: "introduction") as? String
            
            self.navigationItem.title = user.userName //titleにユーザ名を表示
            
            let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error)
                }else{
                    if (data != nil){
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                }
            }

        }else{
            //NCMBUser.currentがnilの時
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "rootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //ログアウト状態保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showMenu() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil {
                    print(error)
                }else{
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "rootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログアウト状態保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()

                }
            })
        }
        
        let deleteOutAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                }else{
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "rootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログアウト状態保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
                
            })        
        }
        
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
