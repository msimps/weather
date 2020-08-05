//
//  Session.swift
//  Weather
//
//  Created by Matthew on 27.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

class Session{
    var userId: String  = "293515542"
    var token: String = "b46a45d23629cb0ddd0"
    var name: String = ""
    
    static let currentUser = Session()
    private init() {}
    
}
