//
//  MessageToMeViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/18/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class MessageToMeViewController: UIViewController {

    
    
    @IBOutlet weak var tablemessag: UITableView!
    
    let Authentication = Auth.auth()
    let database = Database.database()
    let storage = Storage.storage()
    
    var messageArray : [Message] = [Message]()
    var path = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 reteive()
        tablemessag.rowHeight = UITableView.automaticDimension
//        tablemessag.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func reteive(){
    
    guard let AuthUID = Authentication.currentUser?.uid else {return}
    let messageDB = database.reference(withPath: "Mesaages").child("\(AuthUID)")
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String , String>
        
    
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            // Array of Database
            self.messageArray.append(message)
    
    self.tablemessag.reloadData()
    })
  
    
    }
    
}

//******************
//MARK: - Extension table
extension MessageToMeViewController : UITableViewDelegate,UITableViewDataSource {
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCellToMeSettingTableViewCell
        
        cell.lable.text =  messageArray[indexPath.row].sender
    
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        path = indexPath.row
        tablemessag.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ToMessageHome", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMessageHome" {
            let vc = segue.destination as! BodyMessageViewController
            vc.message = messageArray[path].messageBody
        }
    }
}

