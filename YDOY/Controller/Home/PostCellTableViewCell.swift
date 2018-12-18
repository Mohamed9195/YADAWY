//
//  PostCellTableViewCell.swift
//  YADWY
//
//  Created by mohamed hashem on 12/18/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dislike: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var likoebutton: UIButton!
    @IBOutlet weak var dislikebuttonn: UIButton!
    
    var likebutton: (()->())?
    var dislikebutton: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likePress(_ sender: Any) {
        likebutton!()
    }
    @IBAction func dislikepress(_ sender: Any) {
        dislikebutton!()
    }
    

}
