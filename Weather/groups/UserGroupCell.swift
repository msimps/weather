//
//  UserGroupCell.swift
//  Weather
//
//  Created by Matthew on 22.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class UserGroupCell: UITableViewCell {

    @IBOutlet weak var groupAvatar: AvatarView!
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
