//
//  ProfileTableViewCell.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/12.
//  Copyright © 2015年 李冬. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell{
    @IBOutlet var cellName: UILabel!

    @IBOutlet var cellIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
