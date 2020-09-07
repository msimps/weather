//
//  FeedViewCell.swift
//  Weather
//
//  Created by Matthew on 30.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit






class PostViewCell: UITableViewCell {
    @IBOutlet weak var avatar: AvatarView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postCreatedAt: UILabel!
    
    //@IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
    @IBOutlet weak var likesBtn: LikesView!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var viewsCountBtn: UIButton!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var contentAreaView: UIView!
    
    private var post: FakePost!
    private var screenWidth: CGFloat = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentsBtn.imageView?.tintColor = #colorLiteral(red: 0.3868867159, green: 0.4266083837, blue: 0.4807036519, alpha: 1)
        shareBtn.imageView?.tintColor = #colorLiteral(red: 0.3868867159, green: 0.4266083837, blue: 0.4807036519, alpha: 1)
        viewsCountBtn.imageView?.tintColor = #colorLiteral(red: 0.3868867159, green: 0.4266083837, blue: 0.4807036519, alpha: 1)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //updateComponent()
    }
    
    private func updateComponent(){
        // fill common fields
        avatar.avatarImage = UIImage(named: post.user.avatar)!
        userName.text = post!.user.name
        postCreatedAt.text = post!.created_at
        likesBtn.likesCount = post!.likesCount
        commentsBtn.titleLabel?.text = String(post.commentsCount)
        viewsCountBtn.titleLabel?.text = String(post.viewsCount)
        
        if post.contentType == .text{
            postImage.image = nil
            postImage.isHidden = true
            //postImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            //postText.text
            //let text = (post.content as! TextPostContent).text
            
            let textContentView = TextPostContentView()
            textContentView.setup(content: post.content as! TextPostContent)
            contentAreaView.addSubview(textContentView)
            textContentView.frame = contentAreaView.bounds
            
            
            
        }
        
        if post.contentType == .photo{
            postImage.image = UIImage(named: (post.content as! PhotoPostContent).image)!
            //postImage.image = resizeImage(image: image, targetWidth: screenWidth)
            //postImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            postText.text = ""
            postText.isHidden = true
        }
        

    }

    override func prepareForReuse() {
        postText.text = ""
        postImage.image = nil
        commentsBtn.titleLabel?.text = ""
        viewsCountBtn.titleLabel?.text = ""
        likesBtn.liked = false
        likesBtn.likesCount = 0
    }
    
    func resizeImage(image: UIImage, targetWidth: CGFloat) -> UIImage? {
        let size = image.size
        let ratio  = targetWidth / size.width

        // Figure out what our orientation is, and use that to form the rectangle
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext()}

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func set(post: FakePost, screenWidth: CGFloat){
        self.post = post
        self.screenWidth = screenWidth
        updateComponent()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
