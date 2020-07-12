//
//  UserListController.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class UserListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var tmpUsers = ["Albert Einstein", "Bill Gates", "Bill Gates","Bill Gates","Elon Musk","Elon Musk","Elon Musk","Elon Musk","Elon Musk", "Jeff Bezos", "Jeff Bezos", "Jeff Bezos", "Sergey Brin", "Sergey Brin", "Sergey Brin"]
    
    
    var userList: [User] = []
    
    var sectionList: [String: [User]] = [:]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        generate_tmp_user()
        updateSectionList(userList)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        generate_tmp_user()
        updateSectionList(userList)
        
    }
    
    private func generate_tmp_user(){
        //Fill tmp users
        for user in tmpUsers.sorted() {
            var userPhoto: [UserPhoto] = []
            for i in 1...3 {
                userPhoto.append(UserPhoto(image: "\(user)/\(i)", likes: Int.random(in: 0...50)))
            }
            userList.append(User(name: user, userPhoto: userPhoto))
        }
        let default_photos = Array(1...3).map{ _ in UserPhoto(image: "default_user_avatar", likes: 0) }
        for i in 1...10 {
            userList.append(User(name: "User\(i)", userPhoto: default_photos))
            tmpUsers.append("User\(i)")
        }
    }
    
    func updateSectionList(_ users: [User]){
        sectionList = [:]
        let firstLetters = User.extractUniqLetters(users.map {$0.name})
        firstLetters.forEach({(letter: String) in
            sectionList[letter] = users.filter { $0.name.hasPrefix(letter)}
        })
        //sectionList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")

        tableView.dataSource = self
        tableView.delegate = self
        letterPicker.letterPikerDelegate = self
        letterPicker.letterArray = Array(sectionList.keys).sorted()
        searchBar.delegate = self
        
        
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionList[Array(sectionList.keys).sorted()[section]]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = sectionList[Array(sectionList.keys).sorted()[indexPath.section]]![indexPath.row]
        cell.nameLabel.text = user.name
        // Configure the cell...
        cell.avatarView.avatarImage = UIImage(named: user.avatar)!

        cell.alpha = 0
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                cell.frame.origin.x -= 50
                cell.frame.size.width -= CGFloat(50)
                cell.alpha = 1
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(sectionList.keys).sorted()[section]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userIndex = tableView.indexPathForSelectedRow else { return }
        let userPhotosVC = segue.destination as! PhotoSwiperViewController
        userPhotosVC.user = sectionList[Array(sectionList.keys).sorted()[userIndex.section]]![userIndex.row]
    }

}


extension UserListController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            updateSectionList(userList)
            letterPicker.letterArray = Array(sectionList.keys).sorted()
        } else {
            updateSectionList(userList.filter {$0.name.contains(searchText)} )
            letterPicker.letterArray = Array(sectionList.keys).sorted()
        }
        tableView.reloadData()
        //print(searchText)
    }
    
}

extension UserListController: LetterPickerDelegate{
    func didSelectRow(index: Int) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
    }

}

class Custom2NavigationController: UINavigationController{}

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    
    let interactiveTransition = CustomInteractiveTransition()

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(operation)
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }

}


final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
           
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)
        destination.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                source.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                destination.view.transform = .identity
        },
            completion: {finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
           }
       )
    }
}

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
           
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)
        destination.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.center = CGPoint(x: source.view.bounds.width, y: 0.0)
           
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                source.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                destination.view.transform = .identity
        },
            completion: {finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
           }
       )
    }
    
}


class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(
                target: self,
                action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.top]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        print(recognizer)
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.33

            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }

    
}

