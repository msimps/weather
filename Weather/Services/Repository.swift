//
//  Repository.swift
//  Weather
//
//  Created by Matthew on 13.08.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation


class Repository{
    static let realm = RealmRepository()
    static let firebase = FirebaseRepository()
    private init() {}

}






