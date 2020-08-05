//
//  UserListController.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import Kingfisher

class UserListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    //var tmpUsers = ["Albert Einstein", "Bill Gates", "Bill Gates","Bill Gates","Elon Musk","Elon Musk","Elon Musk","Elon Musk","Elon Musk", "Jeff Bezos", "Jeff Bezos", "Jeff Bezos", "Sergey Brin", "Sergey Brin", "Sergey Brin"]
    
    
    var userList: [User] = []
    
    var sectionList: [String: [User]] = [:]
    lazy var service = VkApi()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //generate_tmp_user()//
        //updateSectionList(userList)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //generate_tmp_user()
        
        
        
        
    }
    
    /*private func generate_tmp_user(){
        //Fill tmp users
        for user in tmpUsers.sorted() {
            var userPhoto: [Photo] = []
            for i in 1...3 {
                //userPhoto.append(Photo(image: "\(user)/\(i)", likes: Int.random(in: 0...50)))
            }
            userList.append(FakeUser(name: user, userPhoto: userPhoto))
        }
        let default_photos:[Photo] = [] //Array(1...3).map{ _ in Photo(image: "default_user_avatar", likes: 0) }
        for i in 1...10 {
            userList.append(FakeUser(name: "User\(i)", userPhoto: default_photos))
            tmpUsers.append("User\(i)")
        }
    }*/
    
    func updateSectionList(_ users: [User]){
        sectionList = [:]
        let firstLetters = FakeUser.extractUniqLetters(users.map {$0.name})
        firstLetters.forEach({(letter: String) in
            sectionList[letter] = users.filter { $0.name.hasPrefix(letter)}
        })
        //sectionList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getFriend() { users in
          self.userList = users
          self.updateSectionList(self.userList)
          self.tableView.reloadData()
          self.letterPicker.letterArray = Array(self.sectionList.keys).sorted()
        }
        tableView.dataSource = self
        tableView.delegate = self
        letterPicker.letterPikerDelegate = self
        
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
        //cell.avatarView.avatarImage = UIImage(named: user.avatar)!
        if let imageUrl = user.avatar, let url = URL(string: imageUrl) {
            cell.avatarView.imageView.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil, options: nil, progressBlock: nil) {
                   (image, error, cacheType, URL) in
                   cell.setNeedsLayout()
               }
           } else {
               cell.imageView?.image = UIImage(named: "default_user_avatar")
           }
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
    }
    
}

extension UserListController: LetterPickerDelegate{
    func didSelectRow(index: Int) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
    }

}




