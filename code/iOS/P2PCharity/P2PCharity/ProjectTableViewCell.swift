//
//  ProjectTableViewCell.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/12.
//  Copyright © 2015年 李冬. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet var projectRaiserAvatar: UIImageView!
    @IBOutlet var projectRaiserAddress: UILabel!
    @IBOutlet var projectReason: UILabel!
    @IBOutlet var projectTotalLove: UILabel!
    @IBOutlet var projectProgressLabel: UILabel!

    @IBOutlet var projectProgress: UIProgressView!
    @IBOutlet var projectLeftTime: UILabel!
    @IBOutlet var projectRaiserSex: UILabel!
    @IBOutlet var projectRaiserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
