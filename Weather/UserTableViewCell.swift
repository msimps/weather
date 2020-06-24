//
//  UserTableViewCell.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarView: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
