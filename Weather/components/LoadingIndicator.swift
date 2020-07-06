//
//  LoadingIndicator.swift
//  Weather
//
//  Created by Matthew on 05.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var replicatorLayer: CAReplicatorLayer!
    var sourceLayer: CALayer!
    let dotSize = 20
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createComponent()
    }
    
    private func createComponent(){
        print(#function)
        replicatorLayer = CAReplicatorLayer()
        sourceLayer = CALayer()
        
        self.layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(sourceLayer)
        
        replicatorLayer.frame = self.bounds
        replicatorLayer.position = self.center
        print("view center=\(self.center) bounds=\(self.bounds) frame=\(self.frame)")
        
        sourceLayer.frame = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        sourceLayer.cornerRadius = CGFloat(dotSize)/2
        sourceLayer.backgroundColor = UIColor.white.cgColor
        sourceLayer.position = self.center
        sourceLayer.anchorPoint = CGPoint(x: 2, y: 5)
        runAnimation()
        
        
    }
    
    func runAnimation(){
        let delay = 0.4
        let elementCount = 3
        replicatorLayer.instanceCount = elementCount
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0) //CATransform3DMakeRotation(CGFloat(2.0*Double.pi)/CGFloat(elementCount), 0, 0, 1)
        replicatorLayer.instanceDelay = delay
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = delay*Double(elementCount)
        opacityAnimation.repeatCount = Float.infinity
        
        sourceLayer.add(opacityAnimation, forKey: nil)
        
    }

}
