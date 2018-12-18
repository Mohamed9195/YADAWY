//
//  ViewController.swift
//  YDOY
//
//  Created by mohamed hashem on 12/9/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications

class FIRSTPAGEViewController: UIViewController , GIDSignInUIDelegate{
    
    
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var YadawyButton: UIButton!
    @IBOutlet weak var BackGround: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for background photo
        
        
        // notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound ]) { (didAllow, error) in }
        
//        //Google account
//        if Auth.auth().currentUser?.email != nil || GIDSignIn.sharedInstance().hasAuthInKeychain(){
//            performSegue(withIdentifier: "ToHome1", sender: self)
//
//            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
//                GoogleButton.setTitle("Continue As GOOGLE", for: .normal)
//            }else{
//                YadawyButton.setTitle("Continue As YADAWY", for: .normal)
//            }
//
//        }
        
        n()
    }
    
    func n(){
        
        if Auth.auth().currentUser?.uid != nil || GIDSignIn.sharedInstance().hasAuthInKeychain() == true {
            performSegue(withIdentifier: "ToHome1", sender: self)
            
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                GoogleButton.setTitle("Continue As GOOGLE", for: .normal)
            }else{
                YadawyButton.setTitle("Continue As YADAWY", for: .normal)
            }
            
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //Google account
        if Auth.auth().currentUser?.uid != nil || GIDSignIn.sharedInstance().hasAuthInKeychain() == true {
            performSegue(withIdentifier: "ToHome1", sender: self)
            
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                GoogleButton.setTitle("Continue As GOOGLE", for: .normal)
            }else{
                YadawyButton.setTitle("Continue As YADAWY", for: .normal)
            }
            
        }
    }
    
    
    
    //MARK: - Login GOOGLE
    @IBAction func LoginWithGoogle(_ sender: Any) {
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            GoogleButton.setTitle("Continue As GOOGLE", for: .normal)
            let alert = UIAlertController(title: "Login", message: "Thanks For login By Google", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: {  (UIAlertAction) in
                self.performSegue(withIdentifier: "ToHome1", sender: self)}))
            
            
            guard let AuthUID = Auth.auth().currentUser?.uid else {return}
            let DataToFirebase = [
                "Email" : Auth.auth().currentUser?.email,
                "Password": "0000000",
                "Name": Auth.auth().currentUser?.displayName,
                "phone": "00000000",
                "User-Id" :  AuthUID,
                "lat" : "0.0",
                "long" : "0.0",
                "Address" : "Not yet",
                "Description" : "Not yet",
                "Status" : "0",
                "Work-Type" : "Not yet"
                
            ]
            
            Database.database().reference(withPath: "profile").child("\(AuthUID)").setValue(DataToFirebase, withCompletionBlock: { (error, refernce) in
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    
                }
            })
            
            
            present(alert, animated: true, completion: nil)
            
            
        }else {
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                GIDSignIn.sharedInstance()?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            GoogleButton.setTitle("Continue As GOOGLE", for: .normal)
            YadawyButton.setTitle("Login With Yadawy", for: .normal)
        }
        
    }
    
    
    //MARK: - Login YaWy
    @IBAction func LoginWithYadwy(_ sender: Any) {
        
        if checklog() == true {
            
        }else{
        
        if Auth.auth().currentUser?.email != nil {
            performSegue(withIdentifier: "ToHome1", sender: self)
        }
        }
    }
    
    
    
    func checklog()-> Bool{
        let index = Auth.auth().currentUser?.email!.firstIndex(of: "@")
        
        
        let dataChek = Auth.auth().currentUser?.email![index!...]
        if dataChek != "@yadawy.com"{
           
            // sign by google
            return true
            
        }else{
            // sign by yadawy
            
            return false
        }
        
    }
    
    
}

