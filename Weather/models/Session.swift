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
    var token: String = "b46a45d23629cb0ddd03fc9aaca7074f5e69864b45243404726d50f5dac6b3ae68f033b215c34fafaf082"
    var name: String = ""
    
    static let currentUser = Session()
    private init() {}
    
}
