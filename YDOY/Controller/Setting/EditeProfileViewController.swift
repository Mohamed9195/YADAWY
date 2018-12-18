//
//  EditeProfileViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/15/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class EditeProfileViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var aboutmy: UITextView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    let Authentication = Auth.auth()
    let database = Database.database()
    let storage = Storage.storage()
    
    let picker = UIImagePickerController()
    let pickerGalary = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reteive()
        aboutmy.dataDetectorTypes = .all
        aboutmy.layer.borderWidth = 0.5
        aboutmy.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        aboutmy.layer.cornerRadius = 10
        
        self.profilePhoto.layer.cornerRadius = 10
        self.profilePhoto.clipsToBounds = true
        self.profilePhoto.layer.borderWidth = 0.5
        self.profilePhoto.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        
        pickerGalary.delegate = self
        pickerGalary.allowsEditing = true
        pickerGalary.sourceType = .photoLibrary
        // Do any additional setup after loading the view.
    }
    
    //MARK: - retrive data
    func reteive(){
        
        guard let AuthUID = Authentication.currentUser?.uid else {return}
        let messageDB = database.reference(withPath: "profile").child("\(AuthUID)")
        messageDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String , String>
            
            self.name.text = snapshotValue["Name"]!
            self.address.text = snapshotValue["Address"]!
            self.phone.text = snapshotValue["phone"]!
//            self.craft.text = snapshotValue["Work-Type"]!
            self.aboutmy.text = snapshotValue["Description"]!
            self.password.text = snapshotValue["Password"]!
            
            
        })
        DispatchQueue.global().async {
            // photo
            let islandRef = self.storage.reference(withPath: "profilePhoto").child("\(self.Authentication.currentUser!.uid)")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if error != nil {
                    print("nnnnnnnnnnn")
                } else {
                    DispatchQueue.main.async {
                        self.profilePhoto.image = UIImage(data: data!)
                    }
                    
                }
            }
        }
        
    }
 
    //MARK: - takephoto
    @IBAction func takephoto(_ sender: Any) {
         present(picker, animated: true, completion: nil)
    }
    
    //MARK: - opengalary
    @IBAction func opengalary(_ sender: Any) {
         present(pickerGalary, animated: true, completion: nil)
    }
    
    //MARK: - saveData
    @IBAction func saveData(_ sender: Any) {
        guard let AuthUID = Authentication.currentUser?.uid else {return}
        let messageDB = database.reference(withPath: "profile").child("\(AuthUID)")
        let DataToFirebase = [
            "Password": self.password.text!,
            "Name": self.name.text!,
            "phone": self.phone.text!,
            "Address" :  self.address.text!,
            "Description" : self.aboutmy.text!
        ]
        
        messageDB.updateChildValues(DataToFirebase)
       // uploadphoto()
        // upload photo
        let FileUploadData =  profilePhoto.image!.pngData()
        SVProgressHUD.show()
        storage.reference(withPath: "profilePhoto").child("\(Authentication.currentUser!.uid)").putData(FileUploadData!, metadata: nil){ (metadata, error) in
            if error != nil {
                SVProgressHUD.dismiss()
            }
            guard metadata != nil else {
                return
            }
            // finish upokoad
            SVProgressHUD.dismiss()
        }
       // self.navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Update", message: "Your data has updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { (UIAlertAction) in
            //self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
      
        
        
        
        
    }
    
    
    //MARK: - uploade photo
    func uploadphoto() {
        
        let FileUploadData =  profilePhoto.image!.pngData()
        SVProgressHUD.show()
        storage.reference(withPath: "profilePhoto").child("\(Authentication.currentUser!.uid)").putData(FileUploadData!, metadata: nil){ (metadata, error) in
            if error != nil {
                 SVProgressHUD.dismiss()
            }
            guard metadata != nil else {
                return
            }
            SVProgressHUD.dismiss()
          
        }

    }
    
    
}


//MARK: - Extension
extension EditeProfileViewController:  UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhoto.image = photo
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    
    
}
