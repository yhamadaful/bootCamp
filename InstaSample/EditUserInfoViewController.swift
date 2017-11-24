//
//  EditUserInfoViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/09.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserInfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var introductionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        userIdTextField.delegate = self
        introductionTextView.delegate = self
        
        //ユーザ情報取得および表示
        if let user = NCMBUser.current() {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //　画像を呼ばれた時に呼ばれる関数
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = selectedImage.scale(byFactor: 1)
        
        picker.dismiss(animated: true, completion: nil)
        
        //uploadのため
        let data = UIImagePNGRepresentation(resizedImage!) //データ変換
        let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data) as! NCMBFile
        
        file.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                self.userImageView.image = selectedImage
            }
        }) { (progress) in
            print(progress)
        }
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
 
    @IBAction func cloaseEditViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserInfo(){
       let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "displayName")
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
    
    
    }
    
}
