//
//  FeedViewController.swift
//  Weather
//
//  Created by Matthew on 01.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newsfeed: VkNewsfeed!
       
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsfeed.posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! PostViewCell
        let post = newsfeed.posts[indexPath.row]
        
        if post.source_id > 0 {
            cell.set(post: post, user: newsfeed.users[post.source_id]!, screenWidth: tableView.frame.width)
        } else {
            cell.set(post: post, user: newsfeed.groups[abs(post.source_id)]!, screenWidth: tableView.frame.width)
        }
        
        
        return cell
    }
   
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        
        VkApi().getNewsfeed { (newsfeed: VkNewsfeed) in
            print(newsfeed)
            self.newsfeed = newsfeed
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
        
        
        
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
