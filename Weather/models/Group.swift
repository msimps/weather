//
//  VkGroup.swift
//  Weather
//
//  Created by Matthew on 21.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift

final class Group: Object, Decodable{
    @objc dynamic var name: String = ""
    @objc dynamic var avatar: String? = ""
    
    
    enum CodingKeys: String, CodingKey {
      case avatar = "photo_200"
      case name
    }
    
    //static func == (lhs: Group, rhs: Group) -> Bool {
    //    return lhs.name == rhs.name
    //}
}
