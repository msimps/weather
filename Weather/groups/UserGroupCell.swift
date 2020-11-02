//
//  UserGroupCell.swift
//  Weather
//
//  Created by Matthew on 22.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class UserGroupCell: UITableViewCell {

    @IBOutlet weak var groupAvatar: AvatarView!{
        didSet{
            groupAvatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var groupName: UILabel! {
        didSet{
            groupName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func avatarFrame(){
        guard let _ = groupAvatar else {return}
        let avatarSize = CGSize(width: ceil(bounds.height), height: ceil(bounds.height))
        let avatarCoordinates = CGPoint(x: 0, y: 0)
        groupAvatar.frame = CGRect(origin: avatarCoordinates, size: avatarSize)
    }
    
    func groupNameFrame(){
        guard let _ = self.groupName else {return}
        let groupNameSize = CGSize(width: ceil(bounds.width - bounds.height), height: ceil(bounds.height))
        let groupNameCoordinates = CGPoint(x: bounds.height, y: 0)
        groupName.frame = CGRect(origin: groupNameCoordinates, size: groupNameSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarFrame()
        groupNameFrame()
    }
    
    

}
