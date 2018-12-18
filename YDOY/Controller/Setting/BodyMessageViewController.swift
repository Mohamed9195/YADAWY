//
//  BodyMessageViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/18/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class BodyMessageViewController: UIViewController {

    @IBOutlet weak var bodymessage: UITextView!
    var message: String? {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bodymessage.dataDetectorTypes = .all
        bodymessage.text = message!
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

}
