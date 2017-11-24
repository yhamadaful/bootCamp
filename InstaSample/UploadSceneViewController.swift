//
//  UploadSceneViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/10.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class UploadSceneViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var uploadImageView: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var discriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        discriptionTextView.delegate = self
        
        
        let today = Date()
        let sec = today.timeIntervalSince1970 as Double
        print(String(sec))
        
        //ユーザ情報取得および表示
        if let user = NCMBUser.current() {
            /*　特に書くものはない
            userIdTextField.text = user.userName
            userNameTextField.text = user.object(forKey: "displayName") as? String
            introductionTextView.text = user.object(forKey: "introduction") as? String
            
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
             */
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
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        uploadImageView.image = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImage(){
        let actionController = UIAlertController(title: "画像選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ機能
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この機種ではカメラが使用できません")
            }
        }
        let libraryAction = UIAlertAction(title: "ライブラリ", style: .default) { (action) in
            //ファイル
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この機種ではライブラリが使用できません")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(libraryAction)
        actionController.addAction(cancelAction)
        
        self.present(actionController, animated: true, completion: nil)
    }
   
    @IBAction func uploadImageInfo(){
        // 画像のupを追加
        if let selectedImage = uploadImageView.image {
        
            let resizedImage = selectedImage.scale(byFactor: 0.4)
            
            //uploadのため
            let data = UIImagePNGRepresentation(resizedImage!) //データ変換
            let fileName1 = NCMBUser.current().objectId as String
            let today = Date()
            let sec = today.timeIntervalSince1970 as Double
            
            let fileName = fileName1 + String(sec)
            let file = NCMBFile.file(withName:fileName , data: data) as! NCMBFile
            
        
            file.saveInBackground({ (error) in
                if error != nil{
                    print(error)
                }else{
                    let obj = NCMBObject(className: "uploadFile")
                    let userId = NCMBUser.current().userName
                    obj?.setObject(userId, forKey: "userId")
                    obj?.setObject(self.titleTextField.text, forKey: "fileTitle")
                    obj?.setObject(self.discriptionTextView.text, forKey: "fileDiscription")
                    obj?.setObject(fileName, forKey: "fileName")

                    obj?.saveInBackground({ (error) in
                        if error != nil {
                            print(error)
                        }else{
                            let alertController = UIAlertController(title: "保存完了", message: "保存が完了しました", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                            
                            self.titleTextField.text = nil
                            self.discriptionTextView.text = nil
                            self.uploadImageView.image = nil
                            
                            
                        }
                    })
                }
            }) { (progress) in
                print(progress)
            }
        }else{
            print("画像を選択してください")
        }
        
        
    }


}
