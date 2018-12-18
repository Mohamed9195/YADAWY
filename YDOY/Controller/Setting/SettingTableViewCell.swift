//
//  SettingTableViewCell.swift
//  YADWY
//
//  Created by mohamed hashem on 12/15/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var lable: UILabel!
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
