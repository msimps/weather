//
//  PhotoSwiperViewController.swift
//  Weather
//
//  Created by Matthew on 08.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class PhotoSwiperViewController: UIViewController {
    
    var user: User?
    var currentImageView: UIImageView = UIImageView()
    var nextImageView: UIImageView =  UIImageView()
    var currentIndex: Int = 0
    var nextIndex: Int = 0
    var interactiveAnimator: UIViewPropertyAnimator!
    
    var swipeRatioForAction: CGFloat = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        
        //let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        self.view.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view.
        
        self.view.addSubview(nextImageView)
        self.view.addSubview(currentImageView)
        currentImageView.contentMode = .scaleAspectFit
        currentImageView.frame = self.view.bounds
        currentImageView.frame.origin.x = 0
        currentImageView.image =  UIImage(named: user!.userPhoto[currentIndex].image)
        currentImageView.tag = 1
        //print("b = \(imageView.bounds) f = \(imageView.bounds)")
        
        
        nextImageView.contentMode = .scaleAspectFit
        nextImageView.frame = self.view.bounds
        //nextImageView.frame.origin.x = self.view.bounds.width
        nextImageView.tag = 3
        nextImageView.layer.opacity = 0
        
        
        //currentImageView = fillImageView(index: currentIndex, shift: 0)
    }
    
    /*private func fillImageView(index: Int, shift: CGFloat = 0)-> UIImageView{
     let imageView = UIImageView(image: UIImage(named: user!.userPhoto[index].image))
     
     self.view.addSubview(imageView)
     imageView.frame = self.view.bounds
     imageView.frame.origin.x = shift
     //print("b = \(imageView.bounds) f = \(imageView.bounds)")
     imageView.contentMode = .scaleAspectFit
     return imageView
     }*/
    
    
    //@objc func onSwipe(gestureRecognizer: UISwipeGestureRecognizer){
    @objc func onSwipe(_ recognizer: UIPanGestureRecognizer){
        //print(recognizer)
        //gestureRecognizer.state ==
        
        //let derectoion: CGFloat = recognizer
        
        switch recognizer.state {
        case .began:
            print("began")
            let translation = recognizer.translation(in: self.view)
            let direction:CGFloat = translation.x > 0 ? 1 : -1
            
            nextIndex = currentIndex + Int(direction)
            if nextIndex < 0 {
                nextIndex = user!.userPhoto.count - 1
            }
            if nextIndex > user!.userPhoto.count - 1{
                nextIndex = 0
            }
            nextImageView.image = UIImage(named: user!.userPhoto[nextIndex].image)
            self.nextImageView.frame.origin.x = 0// -self.view.bounds.width
            self.nextImageView.transform = .identity
            self.nextImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.nextImageView.layer.opacity = 0
            
            print("translation = \(translation) direction = \(direction)")
            interactiveAnimator =  UIViewPropertyAnimator(
                duration: 0.5,
                dampingRatio: 0.5,
                animations: {
                   
                    //nextImageTransform.translatedBy(x:  -self.view.bounds.width/4, y: 0)
                    
                    self.currentImageView.transform = CGAffineTransform(translationX: self.view.bounds.width*direction , y: 0)
                    
                    //nextImageTransform.scaledBy(x: 1, y: 1)
                    self.nextImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.nextImageView.layer.opacity = 1
                     //CGAffineTransform(translationX: self.view.bounds.width, y: 0)
            })
            interactiveAnimator?.startAnimation()
            
            
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = fabs(translation.x) / self.view.bounds.width
            
        case .ended:
            print("ended")
            interactiveAnimator.stopAnimation(true)
            let translation = recognizer.translation(in: self.view)
            let direction:CGFloat = translation.x > 0 ? 1 : -1
            let ratio = fabs(translation.x) / self.view.bounds.width
            print("ratio = \(ratio)")
            if ( ratio < swipeRatioForAction ){
                interactiveAnimator.addAnimations {
                    self.currentImageView.transform = .identity
                    self.nextImageView.transform = .identity
                    //self.nextImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.nextImageView.layer.opacity = 0
                }
            } else {
                interactiveAnimator.addAnimations {
                    self.currentImageView.transform = CGAffineTransform(translationX: direction*self.view.bounds.width, y: 0)
                    //self.nextImageView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                    self.nextImageView.layer.opacity = 1
                    self.nextImageView.transform =  CGAffineTransform(scaleX: 1, y: 1)
                }
                
                //self.currentImageView.image = UIImage(named: self.user!.userPhoto[self.nextIndex].image)
                
                //self.newImageView = nil
                
                
                interactiveAnimator.addCompletion{ position in
                    switch position {
                    case .end:
                        print("end")
                        
                        self.currentImageView.image = self.nextImageView.image
                        self.currentImageView.transform = .identity
                        //self.nextImageView.transform = .identity
                        //self.nextImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.nextImageView.layer.opacity = 0
                        self.currentIndex = self.nextIndex
                        //self.currentImageView?.removeFromSuperview()
                        
                        //self.currentImageView.frame.origin.x = self.view.bounds.width
                        //let tmpImage = self.currentImageView.image
                        /*self.currentImageView.image = UIImage(named: self.user!.userPhoto[self.nextIndex].image)//self.nextImageView.image
                         self.currentImageView.frame.origin.x = 0
                         self.nextImageView.frame.origin.x = -self.view.bounds.width
                         //self.nextImageView = tmpImageView
                         //self.newImageView = nil
                         //self.currentImageView.frame.origin.x = 0
                         
                         self.interactiveAnimator.fractionComplete = 0
                         
                         self.interactiveAnimator.stopAnimation(true)*/
                    @unknown default:
                        print("unknown")
                    }
                }
                
            }
            interactiveAnimator.startAnimation()
        default: return
        }
        
        
    }
    
    private func desappearingImage(){
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
