//
//  PhotoResponse.swift
//  Weather
//
//  Created by Matthew on 03.08.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

struct VkResponse<T: Decodable>: Decodable{
    var items: [T]
    
    enum CodingKeys: String, CodingKey {
        case response
        case items
    }
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try topContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try container.decode([T].self, forKey: .items)
    }
}
