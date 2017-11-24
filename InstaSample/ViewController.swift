//
//  ViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/09/06.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var timelineTableView: UITableView!
    
    var fileArray = [NCMBObject]()
    var followerNCMBObjct = [NCMBObject]()
    var queryText = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let userId = NCMBUser.current().userName
        let query: NCMBQuery = NCMBQuery(className: "uploadFile")
        query.whereKey("userId", equalTo: userId!)
        query.order(byDescending: "createDate")
        query.findObjectsInBackground { (result, error) in
            if error != nil {
                print(error)
            }else{
                self.fileArray = result as! [NCMBObject]
                //テーブルビューをリロードする
                self.timelineTableView.reloadData()
            }
        }
        timelineTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
       
        let userId = NCMBUser.current().userName
        
        let followerquery = NCMBQuery(className: "userFollow")
        followerquery?.whereKey("currentUser", equalTo: userId)
        followerquery?.whereKey("followFlag", equalTo: true)
        followerquery?.findObjectsInBackground { (result, error) in
            if error != nil {
                print(error)
            }else{
                self.followerNCMBObjct = result as! [NCMBObject]
                print(result)
                
                self.queryText = [String]()
                print("数は")
                print(self.followerNCMBObjct.count)
                
                for i in 0 ..< self.followerNCMBObjct.count
                {
                 self.queryText.append(self.followerNCMBObjct[i].object(forKey: "requestUser") as! String)
                }
                self.queryText.append(userId!)
                
                print("queryList = ")
                print(self.queryText)
                
                let query = NCMBQuery(className: "uploadFile")
                query?.whereKey("userId", containedIn: self.queryText)
                query?.order(byDescending: "createDate")
                query?.findObjectsInBackground { (result, error) in
                    if error != nil {
                        print(error)
                    }else{
                        self.fileArray = result as! [NCMBObject]
                        //テーブルビューをリロードする
                        self.timelineTableView.reloadData()
                    }
                }

  
            }
        }

            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailViewController = segue.destination as! EditFileDataViewController
            let selectedIndex = timelineTableView.indexPathForSelectedRow!
            
            detailViewController.selectedFileData = fileArray[selectedIndex.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // コンテンツ数
        print("コンテンツ数：" + String(fileArray.count))
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        
        //内容
        cell.titleUILabel.text = fileArray[indexPath.row].object(forKey: "fileTitle") as? String
        cell.discriptionTextView.text = fileArray[indexPath.row].object(forKey: "fileDiscription") as? String
    
        
        print(cell.titleUILabel.text)
        
        // 画像取得
        let filename = fileArray[indexPath.row].object(forKey: "fileName") as? String
        
        let file = NCMBFile.file(withName: filename, data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error)
            }else{
                if (data != nil){
                    let image = UIImage(data: data!)
                    cell.fileImageView.image = image
                }
            }
        }
        return cell
    }
    
}

