//
//  AllGroupsController.swift
//  Weather
//
//  Created by Matthew on 21.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import Kingfisher

class AllGroupsController: UITableViewController {
    
    var allGroups: [Group] = []
    lazy var service = VkApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Fill tmp Vk Groups
        service.searchGroups(query: " ") { groups in
            self.allGroups = groups
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupCell", for: indexPath) as! UserGroupCell
        cell.groupName.text = allGroups[indexPath.row].name

        if let imageUrl = allGroups[indexPath.row].avatar, let url = URL(string: imageUrl) {
            cell.groupAvatar.imageView.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil, options: nil, progressBlock: nil) {
                (image, error, cacheType, URL) in
                cell.setNeedsLayout()
            }
        } else {
            cell.imageView?.image = UIImage(named: "default_user_avatar")
        }

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
