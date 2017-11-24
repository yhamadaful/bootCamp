//
//  TimelineTableViewCell.swift
//  InstaSample
//
//  Created by nttr on 2017/10/09.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleUILabel: UILabel!
    @IBOutlet var discriptionTextView: UITextView!
    @IBOutlet var fileImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
