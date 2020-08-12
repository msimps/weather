//
//  UserPhoto.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift

final class Photo: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var image: String?
    @objc dynamic var likes: Int = 0
    @objc dynamic var userId: Int = 0
    
    //@objc dynamic var user: List<User>()
    //let users = LinkingObjects(fromType: User.self, property: "photos")
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "photo_604"
        case likes
        case userId = "owner_id"
    }
    
    enum LikesKeys: String, CodingKey {
        case likes = "count"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["userId"]
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try values.decode(String.self, forKey: .image)
        self.id = try values.decode(Int.self, forKey: .id)
        self.userId = try values.decode(Int.self, forKey: .userId)
        let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try likesValues.decode(Int.self, forKey: .likes)
    }
}

