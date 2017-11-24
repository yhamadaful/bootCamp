
//
//  EditFileDataViewController.swift
//  InstaSample
//
//  Created by nttr on 2017/10/10.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditFileDataViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedFileData:NCMBObject!
    
    @IBOutlet var uploadImageView: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var discriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        discriptionTextView.delegate = self
        
        titleTextField.text = selectedFileData.object(forKey: "fileTitle") as? String
        discriptionTextView.text = selectedFileData.object(forKey: "fileDiscription") as? String
        
        let filename = selectedFileData.object(forKey: "fileName") as? String
        
        let file = NCMBFile.file(withName: filename, data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error)
            }else{
                if (data != nil){
                    let image = UIImage(data: data!)
                    self.uploadImageView.image = image
                }
            }
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
            
            let resizedImage = selectedImage.scale(byFactor: 1)
            
            //uploadのため
            let data = UIImagePNGRepresentation(resizedImage!) //データ変換
            let fileName = selectedFileData.object(forKey: "fileName") as! String
            let file = NCMBFile.file(withName:fileName , data: data) as! NCMBFile
            
            file.saveInBackground({ (error) in
                if error != nil{
                    print(error)
                }else{
                    let userId = NCMBUser.current().userName
                    self.selectedFileData.setObject(userId, forKey: "userId")
                    self.selectedFileData.setObject(self.titleTextField.text, forKey: "fileTitle")
                    self.selectedFileData.setObject(self.discriptionTextView.text, forKey: "fileDiscription")
                    self.selectedFileData.setObject(fileName, forKey: "fileName")
          
                    self.selectedFileData.saveInBackground({ (error) in
                        if error != nil {
                            print(error)
                        }else{
                            let alertController = UIAlertController(title: "保存完了", message: "保存が完了しました", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                            
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
    
    @IBAction func closeEditViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
