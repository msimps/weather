//
//  AvatarView.swift
//  Weather
//
//  Created by Matthew on 24.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

@IBDesignable class AvatarView: UIView {
    
    @IBInspectable var shadowMargin: CGFloat = 10
    
    @IBInspectable var shadowOpacity: CGFloat = 1
    
    @IBInspectable var shadowColor:UIColor = UIColor.black
    
    @IBInspectable var avatarImage: UIImage = UIImage(){
        didSet{
            imageView.image = avatarImage
        }
    }
    var imageView: UIImageView!
    let shadowView: UIView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponent()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupComponent()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //updateComponent()
        //print(#function)
        // Drawing code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateComponent()
        //print(#function)
    }
    
    func updateComponent(){
        let aRect = CGRect(x: 0+shadowMargin, y: 0+shadowMargin, width: (self.bounds.width-2*shadowMargin), height: (self.bounds.height-2*shadowMargin))
        imageView.frame = aRect
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        
        shadowView.frame = aRect
        shadowView.layer.cornerRadius = shadowView.frame.size.height / 2
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOpacity = Float(shadowOpacity)/10
        shadowView.layer.shadowRadius = shadowMargin
    }
    
    func  setupComponent() {
        // define avatar image on a frame
        if imageView == nil {
            imageView = UIImageView(image: avatarImage)
            imageView.contentMode = .scaleAspectFill
            updateComponent()
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            shadowView.backgroundColor = .black
            shadowView.clipsToBounds = true
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowOffset = CGSize(width: -5, height: 5)
            
            self.addSubview(shadowView)
            self.addSubview(imageView)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let shrink:CGFloat = 10
        let originRect = imageView.frame
        let newRect = CGRect(x: originRect.origin.x+shrink, y: originRect.origin.y+shrink, width: originRect.width-2*shrink, height: originRect.height-2*shrink)
        tappedImage.frame = newRect
        shadowView.frame = newRect
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                tappedImage.frame = originRect
                self.shadowView.frame = originRect
            }
        )
    }

}
