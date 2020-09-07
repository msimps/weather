//
//  Post.swift
//  Weather
//
//  Created by Matthew on 02.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation




struct VkFeedUsersResponse: Decodable{
    var items: [User]
    
    enum CodingKeys: String, CodingKey {
        case response
        case items = "profiles"
    }
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try topContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try container.decode([User].self, forKey: .items)
    }
}

struct VkFeedGroupsResponse: Decodable{
    var items: [Group]
    
    enum CodingKeys: String, CodingKey {
        case response
        case items = "groups"
    }
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try topContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try container.decode([Group].self, forKey: .items)
    }
}


struct VkNewsfeed{
    var posts: [Post] = []
    var groups: [Int: Group] = [:]
    var users: [Int: User] = [:]
}

enum PostContentType{
    case text
    case photo
}

class PostContent: Decodable{
}

class TextPostContent: PostContent{
    var text: String = ""
    
    
    enum CodingKeys: String, CodingKey {
      case text
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try values.decode(String.self, forKey: .text)
    }

}

class PhotoPostContent: PostContent{
    var image: [Photo] = []
    
    enum CodingKeys: String, CodingKey {
      //case items
      case photos

    }
    
    enum PhotoKeys: String, CodingKey {
      case items
      //case photos

    }
    convenience required init(from decoder: Decoder) throws {
        
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let photos = try values.nestedContainer(keyedBy: PhotoKeys.self, forKey: .photos)
        self.image = try photos.decode([Photo].self, forKey: .items)
    }
}

class Post: Decodable{
    var id: Int = 0
    var source_id: Int = 0
    var date: Int = 0
    var type: PostContentType = .text
    var content: PostContent? = nil
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var repostsCount: Int = 0
    var viewsCount: Int = 0

    
    enum CodingKeys: String, CodingKey {
      case id = "post_id"
      case source_id
      case date
      case likesCount = "likes"
      case commentsCount = "comments"
      case repostsCount = "reposts"
      case viewsCount
      case type
    }
    
    enum LikesKeys: String, CodingKey {
        case likes = "count"
    }
    
    enum CommentsKeys: String, CodingKey {
        case comments = "count"
    }
    
    enum RepostsKeys: String, CodingKey {
        case reposts = "count"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.source_id = try values.decode(Int.self, forKey: .source_id)
        self.date = try values.decode(Int.self, forKey: .date)
        
        
        if values.contains(.likesCount) {
          let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likesCount)
          self.likesCount = try likesValues.decode(Int.self, forKey: .likes)
        
        let commentsValues = try values.nestedContainer(keyedBy: CommentsKeys.self, forKey: .commentsCount)
        self.commentsCount = try commentsValues.decode(Int.self, forKey: .comments)
        
        let repostsValues = try values.nestedContainer(keyedBy: RepostsKeys.self, forKey: .repostsCount)
        self.repostsCount = try repostsValues.decode(Int.self, forKey: .reposts)
        }

        
        let contentType = try values.decode(String.self, forKey: .type)
        print(contentType)
        if contentType == "post" {
            self.type = .text
            self.content = try TextPostContent(from: decoder)
        } else {
            
            self.type = .photo
            self.content = try PhotoPostContent(from: decoder)
        }
        
        
    }
}
























class Post2{
    let user: FakeUser
    let created_at: String
    let text: String
    let image: String
    var likesCount: Int
    var commentsCount: Int
    var repostsCount: Int
    var viewsCount: Int
    
    init(user: FakeUser,
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
