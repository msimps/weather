//
//  Feed.swift
//  Weather
//
//  Created by Matthew on 03.09.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit



class FakePost{
    let user: FakeUser
    let contentType: PostContentType
    let content: PostContent
    
    let created_at: String
    var likesCount: Int
    var commentsCount: Int
    var repostsCount: Int
    var viewsCount: Int
    
    init(user: FakeUser,
         created_at: String,
         contentType: PostContentType,
         content: PostContent,
         likesCount: Int,
         commentsCount: Int,
         repostsCount: Int,
         viewsCount: Int){
        self.user = user
        self.created_at = created_at
        self.contentType = contentType
        self.content = content
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.repostsCount = repostsCount
        self.viewsCount = viewsCount
    }
}
