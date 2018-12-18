//
//  PostHomeViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/18/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class PostHomeViewController: UIViewController {

    
    @IBOutlet weak var tablePost: UITableView!
    
    let Authentication = Auth.auth()
    let database = Database.database()
    let storage = Storage.storage()
    var counter = 0
    var counter2 = 0
    var counter3: [Int] = []
    var path = 0
    
    var Category :String? {
        didSet{
        
        }
    }
    
    var temparray: [String] = []
    var dataArray: [[String]] = []
    var photoArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         navigationItem.title = Category!
       SVProgressHUD.show()
        
        //tablePost.separatorStyle = .none
        tablePost.rowHeight = UITableView.automaticDimension
        
        retrive()
    }
    
    func retrive() {
        
        
        
        DispatchQueue.global().async {
            
            self.database.reference(withPath: "counter").observe(.value , with: { (data) in
                self.counter = data.value as! Int
               if  self.counter == 0 {
              
                return
                
                }
                for i in 0...self.counter - 1 {
                    guard (self.Authentication.currentUser?.uid) != nil else {return}
                    let messageDB = self.database.reference(withPath: "Post").child("\(self.Category!)").child("\(i)")
                    print("ttttttttttt")
                    messageDB.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as? Dictionary<String , String>
                        if snapshotValue == nil {
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                            }
                            return }
                        if snapshotValue!["Category"]! == self.Category! {
                            self.counter3.append(i)
                            DispatchQueue.main.async {
                                let snapshotValue = snapshot.value as! Dictionary<String , String>

                             
                                self.temparray.append(snapshotValue["Category"]!)
                                self.temparray.append(snapshotValue["Email"]!)
                                self.temparray.append(snapshotValue["Phone"]!)
                                self.temparray.append(snapshotValue["Price"]!)
                                self.temparray.append(snapshotValue["Date"]!)
                                self.temparray.append(snapshotValue["Description"]!)
                                self.temparray.append(snapshotValue["Dislike"]!)
                                self.temparray.append(snapshotValue["Like"]!)
                                self.temparray.append(snapshotValue["Sall"]!)
                                self.temparray.append(snapshotValue["UserId"]!)
                                self.dataArray.append(self.temparray)
                                self.temparray = []
                              
                                // load image
                                guard let AuthUID = self.Authentication.currentUser?.uid else {return}
                                let messageDB = self.storage.reference(withPath: "post").child("\(AuthUID)").child("\(i)")
                                messageDB.getData(maxSize: 10 * 1024 * 1024) { data, error in
                                    if error != nil{
                                        print("mmmm")
                                    }
                                    DispatchQueue.main.async {
                                        self.photoArray.append(UIImage(data: data!)!)
                                        print(self.photoArray)
                                        self.tablePost.reloadData()
                                            SVProgressHUD.dismiss()
                                    }
                                    
                                    
                                }
                                
                            }
                          
                        }
                      
                    })
                   
                }
                
            })
          
           
        }
        
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refresh(_ sender: Any) {
        self.photoArray = []
        self.dataArray = []
        retrive()
        
    }
}

//********************************************************************
//MARK: - Extension table
extension PostHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       

        return photoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablePost.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCellTableViewCell
        if  dataArray.isEmpty != true {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
            }
            cell.date.text! = dataArray[indexPath.row][4]
            cell.info.text! = dataArray[indexPath.row][5]
            cell.phone.text! = dataArray[indexPath.row][2]
            cell.price.text! = dataArray[indexPath.row][3]
            cell.dislike.text! = dataArray[indexPath.row][6]
            cell.like.text! = dataArray[indexPath.row][7]
            cell.photo.image = photoArray[indexPath.row]
            
            cell.likebutton = {
                guard let AuthUID = self.Authentication.currentUser?.uid else {return}
                let messageDB = self.database.reference(withPath: "Post").child("\(AuthUID)").child("\(self.counter3[indexPath.row])")
                let t = String(Int(self.dataArray[indexPath.row][7])! + 1)
                let DataToFirebase = [
                    "Like": t
                ]
                
                messageDB.updateChildValues(DataToFirebase)
                DispatchQueue.main.async {
                  cell.like.text! =  String(Int(cell.like.text!)! + 1)
                    cell.likoebutton.isEnabled = false
                }
            }
            
            cell.dislikebutton = {
                guard let AuthUID = self.Authentication.currentUser?.uid else {return}
                let messageDB = self.database.reference(withPath: "Post").child("\(AuthUID)").child("\(self.counter3[indexPath.row])")
                let t = String(Int(self.dataArray[indexPath.row][6])! + 1)
                let DataToFirebase = [
                    "Like": t
                ]
                
                messageDB.updateChildValues(DataToFirebase)
                DispatchQueue.main.async {
                    cell.dislike.text! = String(Int(cell.dislike.text!)! + 1)
                    cell.dislikebuttonn.isEnabled = false
                }
            }
            
            cell.phone.layer.borderWidth = 0.5
            cell.phone.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
            cell.phone.layer.cornerRadius = 10
            
            cell.date.layer.borderWidth = 0.5
            cell.date.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
            cell.date.layer.cornerRadius = 10
            
            cell.price.layer.borderWidth = 0.5
            cell.price.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
            cell.price.layer.cornerRadius = 10
            
            cell.photo.layer.borderWidth = 0.5
            cell.photo.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
            cell.photo.layer.cornerRadius = 10
            
            cell.info.layer.borderWidth = 0.5
            cell.info.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
            cell.info.layer.cornerRadius = 10
            cell.info.isEditable = false
            
            
            
            return cell
        }else{
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
            }
            cell.textLabel?.text = "No Post Yet thank for using app"
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        path = indexPath.row
        tablePost.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "SendMessage", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendMessage" {
            let vc = segue.destination as! MessageViewController
            vc.id = dataArray[path][9]
        }
    }
}
