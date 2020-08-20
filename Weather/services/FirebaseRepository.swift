//
//  Firebase.swift
//  Weather
//
//  Created by Matthew on 20.08.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseRepository{
    var userRef: DatabaseReference?
    
    func setUserRef(_ userId: String){
        let ref = Database.database().reference(withPath: "users")
        //let user = [userId: ["groups": Array<Int>()]]
        //ref.setValue(user)
        userRef = ref.child(userId)
    }
    
    func addGroup(_ groupId: String, _ name: String){
        userRef?.child("groups").child(groupId).setValue(name)
    }
    
}
