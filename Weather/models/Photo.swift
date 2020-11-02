//
//  UserPhoto.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import RealmSwift

final class Photo: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var image: String?
    @objc dynamic var likes: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var albumId: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    
    var aspectRatio: CGFloat { return width == 0 ? CGFloat(1) : CGFloat(height)/CGFloat(width) }
    //@objc dynamic var user: List<User>()
    //let users = LinkingObjects(fromType: User.self, property: "photos")
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "photo_604"
        case likes
        case userId = "owner_id"
        case albumId = "album_id"
        case height
        case width
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
        self.albumId = try values.decode(Int.self, forKey: .albumId)
        self.height = try values.decode(Int.self, forKey: .height)
        self.width = try values.decode(Int.self, forKey: .width)
        let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try likesValues.decode(Int.self, forKey: .likes)
    }
}

final class FeedPhoto: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var image: String?
    @objc dynamic var likes: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }
    
    //@objc dynamic var user: List<User>()
    //let users = LinkingObjects(fromType: User.self, property: "photos")
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "photo_604"
        case likes
        case userId = "owner_id"
        case width
        case height
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
        self.width = try values.decode(Int.self, forKey: .width)
        self.height = try values.decode(Int.self, forKey: .height)
        let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try likesValues.decode(Int.self, forKey: .likes)
    }
}

struct FakePhoto{
    let image: String
    let likes: Int
}

