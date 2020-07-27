//
//  FeedViewController.swift
//  Weather
//
//  Created by Matthew on 01.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let postList: [Post] = [
        Post(user: User(name: "Bill Gates", userPhoto: [UserPhoto(image: "Bill Gates/1", likes: 50)]), created_at: "8 minutes ago", text: "GShard: Scaling Giant Models with Conditional Computation and Automatic Sharding https://arxiv.org/abs/2006.16668", image: "", likesCount: 23, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        
        Post(user: User(name: "Elon Musk", userPhoto: [UserPhoto(image: "Elon Musk/1", likes: 63)]), created_at: "3 hours ago", text: "Going to the Mars! Who with me?", image: "Elon Musk/1", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        
        Post(user: User(name: "Sergey Brin", userPhoto: [UserPhoto(image: "Sergey Brin/1", likes: 63)]), created_at: "5 hours ago", text: "", image: "Sergey Brin/1", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        Post(user: User(name: "Sergey Brin", userPhoto: [UserPhoto(image: "Sergey Brin/1", likes: 63)]), created_at: "5 hours ago", text: "Mmmm, strawberry!!", image: "Sergey Brin/2", likesCount: 22, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        
        
        
        Post(user: User(name: "Albert Einstein", userPhoto: [UserPhoto(image: "Albert Einstein/1", likes: 63)]), created_at: "70 years ago", text: "", image: "", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        Post(user: User(name: "Albert Einstein", userPhoto: [UserPhoto(image: "Albert Einstein/1", likes: 63)]), created_at: "70 years ago", text: "Check it out my haircut!", image: "Albert Einstein/3", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        Post(user: User(name: "Albert Einstein", userPhoto: [UserPhoto(image: "Albert Einstein/1", likes: 63)]), created_at: "70 years ago", text: "", image: "Albert Einstein/2", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedViewCell
        let post = postList[indexPath.row]
        cell.set(post: post, screenWidth: tableView.frame.width)
        return cell
    }
   
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FeedViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        showHelloMessage()
    }
    
    
    func showHelloMessage() {
        let alter = UIAlertController(title: "Wow!", message: "Hi, \(Session.currentUser.name)! How are you?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Great!", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
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
