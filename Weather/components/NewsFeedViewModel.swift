//
//  NewsFeedViewModel.swift
//  Weather
//
//  Created by Matthew on 02.11.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

struct PostViewModel {
    var userName: String = ""
    var userAvatar: String? = nil
    var createdAt: String = ""
    var likesCount: Int = 0
    var commentsCount: String = "0"
    var viewsCount: String = "0"
    var postType: PostContentType = .text
    var postImage: String? = nil
    var postText: String?
    var postTextIsHidden: Bool = false
    var postImageIsHidden: Bool = true
    var showMoreButtonIsHidden: Bool = true
}

final class PostViewModelFactory {
    
    func  constructViewModels(from newsfeed: VkNewsfeed) -> [PostViewModel] {
        let newsFeedViewModels:[PostViewModel] =
            newsfeed.posts.compactMap({ (post) -> PostViewModel in
              if post.source_id > 0 {
                   return viewModel(from: post, user: newsfeed.users[post.source_id]!)
              } else {
                   return viewModel(from: post, user: newsfeed.groups[abs(post.source_id)]!)
              }
            })
        
        return newsFeedViewModels
    }
    
    private func viewModel(from post: Post, user: HeaderStruct) -> PostViewModel {
        var viewModel = PostViewModel()
        viewModel.userAvatar = user.avatar
        viewModel.userName = user.name
        viewModel.createdAt = getCellDateText(post.date)
        viewModel.likesCount = post.likesCount
        viewModel.commentsCount = String(post.commentsCount)
        viewModel.viewsCount = String(post.viewsCount)
        if post.type == .text{
            let content = (post.content as! TextPostContent)
            viewModel.postText = content.text
            viewModel.postImage = nil
            viewModel.postTextIsHidden = false
            viewModel.postImageIsHidden = true
        }
        
        if post.type == .photo{
            let content = post.content as! PhotoPostContent
            viewModel.postImage = content.image.first?.image ?? "default_user_avatar"
            viewModel.postText = nil
            viewModel.postTextIsHidden = true
            viewModel.postImageIsHidden = false
        }
        
        return viewModel
    }
    
    private var formattedDates: [Int: String] = [:]
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        return df
    }()
    
    func getCellDateText(_ date: Int) -> String{
        if let dateText = formattedDates[date] {
            return dateText
        } else {
            let dateText = Self.dateFormatter.string(from: Date(timeIntervalSince1970: Double(date)))
            formattedDates[date] = dateText
            return dateText
        }
    }
}
