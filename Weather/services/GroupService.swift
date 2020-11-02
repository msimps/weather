//
//  GroupService.swift
//  Weather
//
//  Created by Matthew on 02.11.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift

class GroupService{
    private let service = VkApi()
    var notificationToken: NotificationToken?
    
    func getGroups( then completion: @escaping ([Group]) -> Void) {
        guard
            let realm = try? Realm()
        else { return }
        let realmGroups = realm.objects(Group.self)
        notificationToken?.invalidate()

        let token = realmGroups.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmG, _, _, _):
                let groups = Array(realmG)
                self.notificationToken?.invalidate()
                completion(groups)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        self.notificationToken = token
        service.getGroups()
    }
    
   

}
