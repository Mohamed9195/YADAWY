//
//  InfoUserTableViewCell.swift
//  YADWY
//
//  Created by mohamed hashem on 12/15/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class InfoUserTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
