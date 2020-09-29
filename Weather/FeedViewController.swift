//
//  FeedViewController.swift
//  Weather
//
//  Created by Matthew on 01.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsfeed: VkNewsfeed!
    var formattedDates: [Int: String] = [:]
    var isLoading = false


    
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

        VkApi().getNewsfeed(parameters: ["start_time": mostFreshNewsDate+1]) { [weak self] (newsfeed: VkNewsfeed) in
            //print(newsfeed)
            
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            guard newsfeed.posts.count > 0 else { return }
            
            // формируем IndexSet свежедобавленных секций и обновляем таблицу
            
            self.newsfeed.merge(newsfeed, toEnd: false)
            //let indexSet = IndexSet(integersIn: 0..<(newsfeed.posts.count))
            //self.tableView.insertSections(indexSet, with: .automatic)
            self.tableView.reloadData()
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
        
        cell.delegate = self
       
        let post = newsfeed.posts[indexPath.row]
        
        if post.source_id > 0 {
            cell.set(post: post, user: newsfeed.users[post.source_id]!, formattedTime: getCellDateText(post.date), screenWidth: tableView.frame.width)
        } else {
            cell.set(post: post, user: newsfeed.groups[abs(post.source_id)]!, formattedTime: getCellDateText(post.date), screenWidth: tableView.frame.width)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableWidth = tableView.bounds.width
        let post = self.newsfeed.posts[indexPath.row]

        if post.type == .photo{
            let content = post.content as! PhotoPostContent
            let cellHeight = Int(tableWidth * content.image.first!.aspectRatio) +
                PostViewCell.headerHeight +
                PostViewCell.footerHeight + 5*3
            return CGFloat(cellHeight)
        }
        
        return UITableView.automaticDimension
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
        tableView.prefetchDataSource = self
        
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

extension FeedViewController: PostViewCellDelegate{
    func didTapShowMore(cell: PostViewCell) {
        tableView.beginUpdates()
        cell.isExpanded.toggle()
        tableView.endUpdates()
    }
}

extension FeedViewController: UITableViewDataSourcePrefetching{

    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard
            isLoading == false,
            let maxSection = indexPaths.map({ $0.row }).max(),
            maxSection > newsfeed.posts.count - 3
        else {
            return
        }
        
        isLoading = true
        VkApi().getNewsfeed(parameters: ["start_from": newsfeed.next_from]) { [weak self] (newsfeed: VkNewsfeed) in
            
            guard
                let self = self,
                newsfeed.posts.count > 0
            else { return }
            
            self.newsfeed.merge(newsfeed)
            self.tableView.reloadData()
            self.isLoading = false
        }
    }
}
