//
//  PhotoSwiperViewController.swift
//  Weather
//
//  Created by Matthew on 08.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotoSwiperViewController: UIViewController {
    
    lazy var service = VkApi()
    var user: User?
    var userPhoto: [Photo] = []
    
    var currentImageView: UIImageView = UIImageView()
    var nextImageView: UIImageView =  UIImageView()
    var currentIndex: Int = 0
    var nextIndex: Int = 0
    var interactiveAnimator: UIViewPropertyAnimator!
    
    var swipeRatioForAction: CGFloat = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        
        self.view.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view.
        
        self.view.addSubview(nextImageView)
        self.view.addSubview(currentImageView)
        currentImageView.contentMode = .scaleAspectFit
        currentImageView.frame = self.view.bounds
        currentImageView.frame.origin.x = 0
        
        //currentImageView.image =  UIImage(named: user!.userPhoto[currentIndex].image)
        
        
        //updateFromDB()
        
        currentImageView.tag = 1
        
        
        nextImageView.contentMode = .scaleAspectFit
        nextImageView.frame = self.view.bounds
        //nextImageView.frame.origin.x = self.view.bounds.width
        nextImageView.tag = 3
        nextImageView.layer.opacity = 0
        
         
        self.userPhoto = user!.photos
        
        if self.userPhoto.isEmpty {
            service.getPhotosAll(userId: user!.id) {[weak self]
                photos in
                let realm = try! Realm()
                //let friend = self?.user
                //friend?.photos.append(objectsIn: photos)
                try! realm.write {
                    //realm.add(friend!, update: .modified)
                    realm.add(photos, update: .modified)
                }
                self?.updateFromDB()
            }
            
        } else {
            updateFromDB()
        }
    }
    
    func updateFromDB(){
        self.userPhoto = user!.photos
        updateImage(index: self.currentIndex, imageView: self.currentImageView)
    }
    
    func updateImage(index: Int, imageView: UIImageView){
        if let imageUrl = self.userPhoto[self.currentIndex].image, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: ImageResource(downloadURL: url))
        }
    }

    
    @objc func onSwipe(_ recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began:
            
            let translation = recognizer.translation(in: self.view)
            let direction:CGFloat = translation.x > 0 ? 1 : -1
            
            nextIndex = currentIndex + Int(direction)
            if nextIndex < 0 {
                nextIndex = userPhoto.count - 1
            }
            if nextIndex > userPhoto.count - 1{
                nextIndex = 0
            }
            //nextImageView.image = UIImage(named: user!.userPhoto[nextIndex].image)
            
            if let imageUrl = userPhoto[nextIndex].image, let url = URL(string: imageUrl) {
              nextImageView.kf.setImage(with: ImageResource(downloadURL: url))
            }
            
            self.nextImageView.frame.origin.x = 0// -self.view.bounds.width
            self.nextImageView.transform = .identity
            self.nextImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.nextImageView.layer.opacity = 0
            
            interactiveAnimator =  UIViewPropertyAnimator(
                duration: 0.5,
                dampingRatio: 0.5,
                animations: {
                    self.currentImageView.transform = CGAffineTransform(translationX: self.view.bounds.width*direction , y: 0)
                    
                    self.nextImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.nextImageView.layer.opacity = 1
            })
            interactiveAnimator?.startAnimation()

            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = abs(translation.x) / self.view.bounds.width
            
        case .ended:
            //print("ended")
            interactiveAnimator.stopAnimation(true)
            let translation = recognizer.translation(in: self.view)
            let direction:CGFloat = translation.x > 0 ? 1 : -1
            let ratio = abs(translation.x) / self.view.bounds.width
            if ( ratio < swipeRatioForAction ){
                interactiveAnimator.addAnimations {
                    self.currentImageView.transform = .identity
                    self.nextImageView.transform = .identity
                    self.nextImageView.layer.opacity = 0
                }
            } else {
                interactiveAnimator.addAnimations {
                    self.currentImageView.transform = CGAffineTransform(translationX: direction*self.view.bounds.width, y: 0)
                    self.nextImageView.layer.opacity = 1
                    self.nextImageView.transform =  CGAffineTransform(scaleX: 1, y: 1)
                }
                
                
                interactiveAnimator.addCompletion{ position in
                    if  position == .end {
                        self.currentImageView.image = self.nextImageView.image
                        self.currentImageView.transform = .identity
                        self.nextImageView.layer.opacity = 0
                        self.currentIndex = self.nextIndex
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
