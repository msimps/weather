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
    
    func save(_ userId: String, _ token: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userId, forKey: "userId")
        userDefaults.set(token, forKey: "token")
    }
    func load() -> Bool{
        let userDefaults = UserDefaults.standard
        guard userDefaults.string(forKey: "userId") != nil else {
            return false
        }
        userId = userDefaults.string(forKey: "userId")! as String
        token = userDefaults.string(forKey: "token")! as String
        return true
    }
    
    static func validate(_ clousure: @escaping ((_ result: Bool) -> Void)){

        let userDefaults = UserDefaults.standard
        guard userDefaults.string(forKey: "userId") != nil else {
            clousure(false)
            return
        }
        currentUser.userId = userDefaults.string(forKey: "userId")! as String
        currentUser.token = userDefaults.string(forKey: "token")! as String
    
        /*VkApi().getInfo { (response) in
            
            switch response.result{
            case .success(let json):
                let error = json as? [String: Any]
                //print(error)
                print(error?["error"] )
                if error?["error"] == nil {
                    clousure(true)
                } else {
                    clousure(false)
                }
            case .failure(let _):
                clousure(false)
                
            }
        }*/
        
    }
}
