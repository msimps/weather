//
//  Session.swift
//  Weather
//
//  Created by Matthew on 27.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation

class Session{
    var userId: Int = 0
    var token: String = ""
    var name: String = ""
    
    static let currentUser = Session()
    private init() {}
    
}
