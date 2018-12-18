//
//  SettingViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/15/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingViewController: UIViewController {
    
    let SettingArray = ["Edit Profile" , "Sign Out" ,""]
    let photoArray   = ["editprofile.png" , "signout.png" , ""]
    @IBOutlet weak var tableSetting: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableSetting.separatorStyle = .none
        tableSetting.rowHeight = UITableView.automaticDimension
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
}


//********************************************************************
//MARK: - Extension table
extension SettingViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        if indexPath.row == SettingArray.count - 1
        {
            cell.photo.image = UIImage(named: "")
            cell.lable.text = """
            app Develped by:
            mohamed hashem
            """
            return cell
        }
        cell.photo.image = UIImage(named: photoArray[indexPath.row])
        cell.lable.text = SettingArray[indexPath.row]
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toEditProfile", sender: self)
        }else if indexPath.row == 1 {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                GIDSignIn.sharedInstance()?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
           // performSegue(withIdentifier: "signout", sender: self)signout1
            performSegue(withIdentifier: "signout", sender: self)
        }
    }
}

