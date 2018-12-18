//
//  LOGINViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/13/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn

class LOGINViewController: UIViewController {
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    
    let Authontication = Auth.auth()
    let ReferencesFirebase = Database.database().reference(withPath: "Profile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func TestEmail(_ sender: Any) {
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
    
    @IBAction func LoginPress(_ sender: Any) {
        if EmailText.text != "" && passwordText.text != "" {
            SVProgressHUD.show()
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                GIDSignIn.sharedInstance()?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
            Authontication.signIn(withEmail: EmailText.text!, password: passwordText.text!) { (Result, error) in
                if error != nil{
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "ToHomeFromLoginIn", sender: self)
                    
                    
                }
                
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Complete Missing Data", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func FinishShow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
