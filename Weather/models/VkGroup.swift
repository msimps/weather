//
//  VkGroup.swift
//  Weather
//
//  Created by Matthew on 21.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

class VkGroup: Equatable{
    var name: String = ""
    var avatar: String = ""
    
    
    static func == (lhs: VkGroup, rhs: VkGroup) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    
    init(name: String, avatar: String) {
        self.name = name
        self.avatar = avatar
    }

}

class Group: Equatable, Decodable{
    dynamic var name: String = ""
    dynamic var avatar: String? = ""
    
    
    enum CodingKeys: String, CodingKey {
      case avatar = "photo_200"
      case name
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    /*init(name: String, avatar: String) {
        self.name = name
        self.avatar = avatar
    }*/
    /*
    convenience required init(from decoder: Decoder) throws {
      //self.init()
      let topContainer = try decoder.container(keyedBy: CodingKeys.self)
      let container = try topContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
      self.items = try container.decode([T].self, forKey: .items)
      
    }*/
}
