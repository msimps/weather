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
    var formattedDates: [Int: String] = [:]
    
    //var refreshControl: UIRefreshControl?
    
    
   // Функция настройки контроллера
   fileprivate func setupRefreshControl() {
       let refreshControl = UIRefreshControl()
       refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
       refreshControl.tintColor = .systemBlue
       refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
       self.tableView.refreshControl = refreshControl
   }
    
    @objc func refreshNews() {
        self.tableView.refreshControl?.beginRefreshing()
        let mostFreshNewsDate = Double(self.newsfeed.posts.first!.date) ?? Date().timeIntervalSince1970

        VkApi().getNewsfeed(parameters: ["start_time": mostFreshNewsDate]) { [weak self] (newsfeed: VkNewsfeed) in
            //print(newsfeed)
            
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            guard newsfeed.posts.count > 0 else { return }
            self.newsfeed.merge(newsfeed)
            // формируем IndexSet свежедобавленных секций и обновляем таблицу
            let indexSet = IndexSet(integersIn: 0..<newsfeed.posts.count)
            self.tableView.insertSections(indexSet, with: .automatic)

        }
    }

    
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        return df
    }()
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsfeed.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! PostViewCell
        let post = newsfeed.posts[indexPath.row]
        
        if post.source_id > 0 {
            cell.set(post: post, user: newsfeed.users[post.source_id]!, formattedTime: getCellDateText(post.date), screenWidth: tableView.frame.width)
        } else {
            cell.set(post: post, user: newsfeed.groups[abs(post.source_id)]!, formattedTime: getCellDateText(post.date), screenWidth: tableView.frame.width)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Вычисляем высоту
        let tableWidth = tableView.bounds.width
        let post = self.newsfeed.posts[indexPath.row]
        var cellHeight = 0
        if post.type == .text{
            let content = post.content as! TextPostContent
            cellHeight = 200 + 66 + 23
        }else{
            let content = post.content as! PhotoPostContent
            cellHeight = Int(tableView.frame.width*content.image.first!.aspectRatio + 66 + 23)
        }
        return CGFloat(cellHeight)
        

    }
    
    func getCellDateText(_ date: Int) -> String{
        if let dateText = formattedDates[date] {
            return dateText
        } else {
            let dateText = dateFormatter.string(from: Date(timeIntervalSince1970: Double(date)))
            formattedDates[date] = dateText
            return dateText
        }
    }
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        setupRefreshControl()
        VkApi().getNewsfeed { (newsfeed: VkNewsfeed) in
            //print(newsfeed)
            self.newsfeed = newsfeed
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
        
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
