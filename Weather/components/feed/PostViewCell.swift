//
//  FeedViewCell.swift
//  Weather
//
//  Created by Matthew on 30.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import Kingfisher



protocol PostViewCellDelegate: class{
    func didTapShowMore(cell: PostViewCell)
}

class PostViewCell: UITableViewCell {
    @IBOutlet weak var avatar: AvatarView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postCreatedAt: UILabel!
    
    @IBOutlet weak var likesBtn: LikesView!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var viewsCountBtn: UIButton!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    weak var delegate: PostViewCellDelegate?

    
    
    private var post: PostViewModel!

    private var screenWidth: CGFloat = 0
    
    static let instets: CGFloat = 10.0
    static let headerHeight: Int = 66
    static let footerHeight: Int = 23
    static let maxTextHeight: Int = 200
    
    var isExpanded: Bool = false {
        didSet {
            updatePostLabel()
            updateShowMoreButton()
        }
    }
    
    @IBAction func clickShowMore(_ sender: Any) {
        delegate?.didTapShowMore(cell: self)
    }
    
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
        selectionStyle = .none
        // fill common fields
        if let imageUrl = post.userAvatar, let url = URL(string: imageUrl) {
            avatar.imageView.kf.setImage(with: ImageResource(downloadURL: url)) { _ in
                self.setNeedsLayout()
            }
        }

        userName.text = post.userName
        postCreatedAt.text = post.createdAt
        likesBtn.likesCount = post.likesCount
        commentsBtn.titleLabel?.text = post.commentsCount
        viewsCountBtn.titleLabel?.text = post.viewsCount
        
        postText.text = post.postText
        postText.isHidden = post.postTextIsHidden
        postImage.isHidden = post.postImageIsHidden
            
        if let imageUrl = post.postImage, let url = URL(string: imageUrl) {
            postImage.kf.setImage(with: ImageResource(downloadURL: url)) { _ in
                self.setNeedsLayout()
            }
        } else {
            postImage.image = nil
        }
        if let text = post.postText {
            let labelSize = getLabelSize(text: text, font: postText.font)
            showMoreButton.isHidden = labelSize.height < 200
            updatePostLabel()
        } else {
            showMoreButton.isHidden = true
        }
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth =  bounds.width - Self.instets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
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
    
    func set(post: PostViewModel, screenWidth: CGFloat){
        self.post = post
        self.screenWidth = screenWidth
        updateComponent()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updatePostLabel(){
        postText.numberOfLines = isExpanded ? 0 : 10
    }
    
    private func updateShowMoreButton(){
        let title = isExpanded ? "Show less..." : "Show more..."
        showMoreButton.setTitle(title, for: .normal)
    }
    
}
