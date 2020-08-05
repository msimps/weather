//
//  UserPhoto.swift
//  Weather
//
//  Created by Matthew on 20.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

class Photo: Decodable {
    dynamic var image: String?
    dynamic var likes: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case image = "photo_604"
        case likes
    }
    
    enum LikesKeys: String, CodingKey {
        case likes = "count"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try values.decode(String.self, forKey: .image)
        
        let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try likesValues.decode(Int.self, forKey: .likes)
    }
}

