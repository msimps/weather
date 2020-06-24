//
//  LikeControl.swift
//  Weather
//
//  Created by Matthew on 24.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    @IBInspectable var likesCount: Int = 10
    
    @IBInspectable var unlikedColor: UIColor = UIColor.black
    @IBInspectable var likedColor: UIColor = UIColor.red
    @IBInspectable var liked: Bool = false
    
    private var likeBtn: UIButton = UIButton(type: .system)
    
    private var stackView: UIStackView!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        updateComponent()
    }
    
    
    private func updateComponent(){
        if liked {
            likeBtn.setTitle(String(likesCount+1), for: .normal)
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeBtn.tintColor = likedColor
            likeBtn.setTitleColor(likedColor, for: .normal)
        } else {
            likeBtn.setTitle(String(likesCount), for: .normal)
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likeBtn.tintColor = unlikedColor
            likeBtn.setTitleColor(unlikedColor, for: .normal)
        }
    }
    
    
    
    private func setupComponent(){
        likeBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        
        updateComponent()

        stackView = UIStackView(arrangedSubviews: [likeBtn])
        self.addSubview(stackView)
        //stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
    }
    
    @objc private func clickBtn(_ sender: UIButton){
        liked = !liked
        updateComponent()
    }

}
