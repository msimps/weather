//
//  Repository.swift
//  Weather
//
//  Created by Matthew on 13.08.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Repository{
    private let _realm = try! Realm()
    
    static let realm = Repository()
    private init() {}
    
    func save(_ items: [Object]){
        try! _realm.write {
            _realm.add(items, update: .modified)
        }
    }
    
    func load<T: Object>(_ filter: String = "id !=0")-> [T]{
        return Array(_load(filter))
    }
    
    func _load<T: Object>(_ filter: String = "id != 0")-> Results<T>{
      return _realm.objects(T.self).filter(filter)
    }
}

protocol BindRealmToTableView{
    func bindRealmToTableView<T>(tableView: UITableView, results: Results<T>) -> NotificationToken
}

extension BindRealmToTableView{
    
    func bindRealmToTableView<T>(tableView: UITableView, results: Results<T>) -> NotificationToken{
        let notificationToken = results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
            
        }
        return notificationToken
    }
}





