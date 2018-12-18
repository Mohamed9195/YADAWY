//
//  MessageViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/18/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MessageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var messageArray : [Message] = [Message]()
    
    var id :String? {
        didSet{
            
        }
    }
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        retriveMessages()
        configureTableView()
//        messageTableView.separatorStyle = .none
        messageTableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        
        cell.lable.text =  messageArray[indexPath.row].messageBody

        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
       
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
      
        let messageDB = Database.database().reference().child("Mesaages").child("\(id!)")
    
        let messageDictionary = ["sender": Auth.auth().currentUser?.email , "MessageBody": messageTextfield.text!]
        messageDB.childByAutoId().setValue(messageDictionary){
            (error , refernce) in
            if error != nil {
                print("error")
            }else{
                print("sucess send")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
        
    }
    
    
    //TODO: Create the retrieveMessages method here:
    func retriveMessages() {
        
        let messageDB = Database.database().reference().child("Mesaages").child("\(id!)")
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String , String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            // Array of Database
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
        })
        
    }

}
