//
//  User.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift


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

final class User: Object, Decodable{
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatar: String?
    
    var name: String {
        return firstName + " " + lastName
    }
    
    var photos: [Photo] {
        return  Repository.realm.load("userId== \(self.id)")
    }
    //let groups = List<Group>()
    //let photos2 = List<Photo>()
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_200_orig"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }

    
    static func extractUniqLetters(_ str: [String])-> [String]{
        let s = Set(str.map {String($0.uppercased().prefix(1))})
        return Array(s).sorted()
    }
    
    //override static func ignoredProperties() -> [String] {
    //    return ["photos"]
    //}

}

