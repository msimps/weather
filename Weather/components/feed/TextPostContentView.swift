//
//  TextPostContentView.swift
//  Weather
//
//  Created by Matthew on 03.09.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class TextPostContentView: UIView {

    @IBOutlet weak var postText: UITextView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var content: TextPostContent!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupXib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        
        //
        
        
    }
    
    func setup(content: TextPostContent){
        postText.text = content.text
    }
    
    

}
