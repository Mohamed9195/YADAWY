//
//  SellProductViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/16/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SellProductViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var pickerCategory: UIPickerView!
    @IBOutlet weak var DescriprionText: UITextView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    let dataInCategory : [String] = ["clothes" ,"textiles" ,"houseware", "furniture", "beauty", "accessories", "electronics", "toys", "Food", "decoration", "other"]
    var pickerData = ""
    var counter = 0
    var downloadlink: URL?
    
    let Authontication = Auth.auth()
    let database = Database.database()
    let storage = Storage.storage()
    
    let picker = UIImagePickerController()
    let pickerGalary = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        database.reference(withPath: "counter").observe(.value , with: { (data) in
            self.counter = data.value as! Int
        })
        
        photo.layer.borderWidth = 0.5
        photo.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        photo.layer.cornerRadius = 10
        
        DescriprionText.layer.borderWidth = 0.5
        DescriprionText.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        DescriprionText.layer.cornerRadius = 10
        
        pickerCategory.layer.borderWidth = 0.5
        pickerCategory.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        pickerCategory.layer.cornerRadius = 10
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        
        pickerGalary.delegate = self
        pickerGalary.allowsEditing = true
        pickerGalary.sourceType = .photoLibrary
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func PublishPress(_ sender: Any) {
        if DescriprionText.text != "" && phone.text != "" && price.text != "" && phone != nil && pickerCategory != nil{
            SVProgressHUD.show()
            let DateLink  = String(Date().description)
            guard let AuthUID = self.Authontication.currentUser?.uid else {return}
            let DataToFirebase = [
                "Email" : Authontication.currentUser?.email,
                "Category": self.pickerData,
                "Like": "0",
                "Dislike" :  "0",
                "Price" : self.price.text!,
                "Sall" : "Not yet",
                "Description" : self.DescriprionText.text!,
                "Phone" : self.phone.text!,
                "UserId" : AuthUID,
                "Date" : DateLink
            ]
            
            database.reference(withPath: "counter").observe(.value , with: { (data) in
                self.counter = data.value as! Int
            })
         
            
            database.reference(withPath: "Post").child("\(AuthUID)").child("\(counter)").setValue(DataToFirebase) { (error, Refrenc) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    
                    self.database.reference(withPath: "counter").setValue(self.counter + 1 ){ (error, Refrenc) in }
                            // upload photo
                            let FileUploadData =  self.photo.image!.pngData()
                    self.storage.reference(withPath: "post").child("\(self.Authontication.currentUser!.uid)").child("\(self.counter)").putData(FileUploadData!, metadata: nil){ (metadata, error) in
                                if error != nil {
                                    SVProgressHUD.dismiss()
                                }
                                guard metadata != nil else {
                                    return
                                }
                                // finish upokoad
                                self.storage.reference(withPath: "post").child("\(self.Authontication.currentUser!.uid)").downloadURL { (url, error) in
                                    guard let downloadURL = url else {
                                        return
                                    }
                                    
                                     print(downloadURL)
                                }
                                 SVProgressHUD.dismiss()
                            }
                    
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Share Post", message: "Your post uploaded", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Complete Missing Data", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func galary(_ sender: Any) {
          present(pickerGalary, animated: true, completion: nil)
    }
    @IBAction func takePhoto(_ sender: Any) {
          present(picker, animated: true, completion: nil)
    }
}


//MARK: - Picker
extension SellProductViewController : UIPickerViewDataSource , UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataInCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataInCategory[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerData = dataInCategory[row]
    }
}

//MARK: - Extension
extension SellProductViewController:  UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photo.image = photo
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    
    
}
