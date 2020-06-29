//
//  UserListController.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class UserListController: UIViewController, UITableViewDelegate, UITableViewDataSource, LetterPickerDelegate {
    
    func didSelectRow(row: Int) {
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
    }
    
    func dataSource() -> [String] {
        return tmpUsers
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    
    var tmpUsers = ["Albert Einstein", "Bill Gates", "Bill Gates","Bill Gates","Elon Musk","Elon Musk","Elon Musk","Elon Musk","Elon Musk", "Jeff Bezos", "Jeff Bezos", "Jeff Bezos", "Sergey Brin", "Sergey Brin", "Sergey Brin"]
    
    
    var userList: [User] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        generate_tmp_user()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        generate_tmp_user()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.reloadData()
        
        
        letterPicker.letterPikerDelegate = self
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.nameLabel.text = userList[indexPath.row].name
        //cell.avatarImage.image = UIImage(named: userList[indexPath.row].avatar)
        //cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.size.height / 2
        //cell.avatarImage.clipsToBounds = true
        // Configure the cell...
        cell.avatarView.avatarImage = UIImage(named: userList[indexPath.row].avatar)!
        
        return cell
    }
    
  

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userIndex = tableView.indexPathForSelectedRow else { return }
        let userPhotosVC = segue.destination as! UserPhotosController
        userPhotosVC.user = userList[userIndex.row]
    }
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
