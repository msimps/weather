//
//  MyGroupsController.swift
//  Weather
//
//  Created by Matthew on 21.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class MyGroupsController: UITableViewController {
    
    @IBOutlet var myGroupTableView: UITableView!
    var myGroups: [Group] = []
    lazy var service = VkApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UserGroupCell.self, forCellReuseIdentifier: "UserGroupCell")
        
        
        updateFromDB()
        service.getGroups {[weak self] groups in
            let realm = try! Realm()
            try! realm.write {
                realm.add(groups, update: .modified)
            }
            self?.updateFromDB()
        }
    }
    
    func updateFromDB(){
        let realm = try! Realm()
        self.myGroups = Array(realm.objects(Group.self))
        self.tableView.reloadData()
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        //guard let allGroupsController = segue.source as? AllGroupsController, let index = allGroupsController.tableView.indexPathForSelectedRow else { return }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupCell", for: indexPath) as! UserGroupCell
        cell.textLabel?.text = myGroups[indexPath.row].name
        if let imageUrl = myGroups[indexPath.row].avatar, let url = URL(string: imageUrl) {
            cell.imageView?.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil, options: nil, progressBlock: nil) {
                (image, error, cacheType, URL) in
                cell.setNeedsLayout()
            }
        } else {
            cell.imageView?.image = UIImage(named: "default_user_avatar")
        }
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
