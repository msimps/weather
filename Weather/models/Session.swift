//
//  Session.swift
//  Weather
//
//  Created by Matthew on 27.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

class Session{
    var userId: String  = "29351"
    var token: String = "b46a45d23629cb0ddd0"
    var name: String = ""
    
    static let currentUser = Session()
    private init() {}
    
    static func validate() -> Bool{

        let userDefaults = UserDefaults.standard
        guard userDefaults.string(forKey: "userId") != nil else {
            return false
        }
        currentUser.userId = userDefaults.string(forKey: "userId")! as String
        currentUser.token = userDefaults.string(forKey: "token")! as String
    
        VkApi().getInfo()
        
        return true
    }
    
}
