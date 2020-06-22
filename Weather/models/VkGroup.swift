//
//  VkGroup.swift
//  Weather
//
//  Created by Matthew on 21.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

class VkGroup: Equatable{
    static func == (lhs: VkGroup, rhs: VkGroup) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    let avatar: String
    
    init(name: String, avatar: String) {
        self.name = name
        self.avatar = avatar
    }
}
