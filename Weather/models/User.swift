//
//  User.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation


class FakeUser{
    let name: String
    //let avatar: String
    let userPhoto: [Photo]
    
    public var avatar: String {
        //return userPhoto.first != nil ? userPhoto.first!.image : "default_user_avatar"
        return "default_user_avatar"
    }
    
    init(name: String, userPhoto: [Photo]){
        self.name = name
        self.userPhoto = userPhoto
    }
    
    static func extractUniqLetters(_ str: [String])-> [String]{
        let s = Set(str.map {String($0.uppercased().prefix(1))})
        return Array(s).sorted()
    }
}

class User: Decodable{
    var name: String {
        return firstName + " " + lastName
    }
    dynamic var id: Int
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var avatar: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_200_orig"
    }
    
    
    static func extractUniqLetters(_ str: [String])-> [String]{
        let s = Set(str.map {String($0.uppercased().prefix(1))})
        return Array(s).sorted()
    }
}

