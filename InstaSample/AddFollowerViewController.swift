//
//  AddFollowerViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/10.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

class AddFollowerViewController: UIViewController {
    
    @IBOutlet var requestUserTextView: UITextField!
    
    var requestArray = [NCMBObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(){
        let obj = NCMBQuery(className: "userFollow")
        obj?.whereKey("requestUser", equalTo: requestUserTextView.text)
        obj?.whereKey("currentUser", equalTo: NCMBUser.current().userName)
       
        obj?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            }else{
                self.requestArray = result as! [NCMBObject]
                
                if self.requestArray.count <= 0 {
                    // まだ登録がない場合
                    let user = NCMBObject(className: "userFollow")
                    user?.setObject(self.requestUserTextView.text, forKey: "requestUser")
                    user?.setObject(NCMBUser.current().userName, forKey: "currentUser")
                    user?.saveInBackground({ (error) in
                        if error != nil {
                            print(error)
                        }else{
                            let alertController = UIAlertController(title: "申請完了", message: "申請が完了しました", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }else{
                    // すでに登録がある場合　何もしない
                    let alertController = UIAlertController(title: "申請完了", message: "申請が完了しました", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }

    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
