//
//  Post.swift
//  Weather
//
//  Created by Matthew on 02.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation


class Post{
    let user: User
    let created_at: String
    let text: String
    let image: String
    var likesCount: Int
    var commentsCount: Int
    var repostsCount: Int
    var viewsCount: Int
    
    init(user: User,
         created_at: String,
         text: String,
         image: String,
         likesCount: Int,
         commentsCount: Int,
         repostsCount: Int,
         viewsCount: Int){
        self.user = user
        self.created_at = created_at
        self.text = text
        self.image = image
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.repostsCount = repostsCount
        self.viewsCount = viewsCount  
    }
}
