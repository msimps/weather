//
//  Repository.swift
//  Weather
//
//  Created by Matthew on 13.08.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Repository{
    private let _realm = try! Realm()
    
    static let realm = Repository()
    private init() {}
    
    func save(_ items: [Object]){
        try! _realm.write {
            _realm.add(items, update: .modified)
        }
    }
    
    func load<T: Object>(_ filter: String = "select *")-> [T]{
      return Array(_realm.objects(T.self).filter(filter))
    }
}






