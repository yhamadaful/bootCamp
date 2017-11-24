//
//  ApprovalFollowerViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/11.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

class ApprovalFollowerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var userListTableView: UITableView!
    var requestArray = [NCMBObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableView.dataSource = self
        userListTableView.delegate = self

        userListTableView.tableFooterView = UITableView()
        
        loadUserList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadUserList()
    }

    func loadUserList(){
        let query = NCMBQuery(className: "userFollow")
        query?.whereKey("currentUser", equalTo: NCMBUser.current().userName)
        query?.whereKey("followFlag", notEqualTo: true)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            }else{
                self.requestArray = result as! [NCMBObject]
                self.userListTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        /*
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        */
        let alert = UIAlertController(
            title: "ご確認",
            message: "このユーザを承認しますか",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { action in
            let ncmbUser = self.requestArray[indexPath.row]
            ncmbUser.setObject(true, forKey: "followFlag")
            ncmbUser.saveInBackground({ (error) in
                if error != nil {
                    print(error)
                }else{
                    self.loadUserList()
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = requestArray[indexPath.row].object(forKey: "requestUser") as? String
        
        return cell!
    }

    

}
