//
//  SIGNViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/13/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SIGNViewController: UIViewController {
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let Authontication = Auth.auth()
    let database = Database.database()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - chekEmail
    @IBAction func chekEmail(_ sender: Any) {
        let index = EmailText.text!.firstIndex(of: "@")
        if EmailText.text != nil{
            if index != nil {
                let dataChek = EmailText.text![index!...]
                if dataChek != "@yadawy.com"{
                    let alert = UIAlertController(title: "Error", message: "Email shoud finish by @yadawy", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                }else{
                    
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Email shoud finish by @yadawy", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    //MARK: - RegisterPress
    @IBAction func RegisterPress(_ sender: Any) {
        
        if EmailText.text != ""  &&  passwordText.text != ""  &&  nameText.text != "" && phoneText.text != ""{
            SVProgressHUD.show()
            Authontication.createUser(withEmail: EmailText.text!, password: passwordText.text!) { (Result, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    guard let AuthUID = self.Authontication.currentUser?.uid else {return}
                    let DataToFirebase = [
                        "Email" : self.EmailText.text!,
                        "Password": self.passwordText.text!,
                        "Name": self.nameText.text!,
                        "phone": self.phoneText.text!,
                        "User-Id" :  AuthUID,
                        "lat" : "0.0",
                        "long" : "0.0",
                        "Address" : "Not yet",
                        "Description" : "Not yet",
                        "Status" : "0",
                        "Work-Type" : "Not yet"
                        
                    ] 
                    
                    self.database.reference(withPath: "profile").child("\(AuthUID)").setValue(DataToFirebase, withCompletionBlock: { (error, refernce) in
                        if error != nil {
                            
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .actionSheet)
                            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }else {
                            SVProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "ToHomeFromSignUp", sender: self)
                        }
                    })
                }
                
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Complete Missing Data", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - dismis
    @IBAction func FinishView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
