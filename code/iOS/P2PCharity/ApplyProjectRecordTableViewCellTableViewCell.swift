//
//  ApplyProjectRecordTableViewCellTableViewCell.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/4.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class ApplyProjectRecordTableViewCellTableViewCell: UITableViewCell {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var sex: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var progresss: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var applyBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
