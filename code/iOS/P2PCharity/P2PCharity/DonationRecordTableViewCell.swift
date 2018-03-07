//
//  DonationRecordTableViewCell.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/4.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class DonationRecordTableViewCell: UITableViewCell {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var projectTitle: UILabel!
    @IBOutlet var donationMoney: UILabel!
    @IBOutlet var applicationOfMoney: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
