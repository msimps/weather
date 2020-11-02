//
//  CustomGradientView.swift
//  Weather
//
//  Created by Matthew on 25.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

@IBDesignable class CustomGradientView: UIView {
     
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    @IBInspectable var startColor = UIColor.defaultGradientStartColor
    //#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    @IBInspectable var endColor = UIColor.defaultGradientEndColor
    //#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
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
        updateComponent()
    }
    
    func updateComponent(){
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }

    
    private func setupComponent(){
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
