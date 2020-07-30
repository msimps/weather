//
//  VkApi.swift
//  Weather
//
//  Created by Matthew on 29.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import Alamofire

class VkApi {
    let vkEndpoint = "https://api.vk.com/method"
    let apiVersion = "5.52"
    
    func getInfo() {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token
        ]
        AF.request(vkEndpoint + "/account.getInfo", parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    
    func getProfileInfo() {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token
        ]
        AF.request(vkEndpoint + "/account.getProfileInfo", parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    func getFriendIds() {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "user_id": Session.currentUser.userId
        ]
        AF.request(vkEndpoint + "/friends.get", parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    func getPhotosAll() {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "owner_id": Session.currentUser.userId,
            "extended": 1
        ]
        AF.request(vkEndpoint + "/photos.getAll", parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    func getGroups() {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "user_id": Session.currentUser.userId,
            "extended": 1
        ]
        AF.request(vkEndpoint + "/groups.get", parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    func searchGroups(query: String, sort: Int = 0) {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "q": query,
            "sort": sort
        ]
        AF.request(vkEndpoint + "/groups.search", parameters: parameters).responseJSON { response in
            print(response)
        }
    }
    
    
}
