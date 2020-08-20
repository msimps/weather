//
//  VkApi.swift
//  Weather
//
//  Created by Matthew on 29.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class VkApi {
    let vkEndpoint = "https://api.vk.com/method"
    let apiVersion = "5.52"
    
    
    func validateToken(_ clousure: @escaping ((_ result: Bool) -> Void)) {
        
        guard Session.currentUser.load() else {
            clousure(false)
            return
        }
        
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token
        ]
        
        AF.request(vkEndpoint + "/account.getInfo", parameters: parameters).responseJSON { response in
            print(response)
            switch response.result{
            case .success(let json):
                let error = json as? [String: Any]
                //print(error)
                print(error?["error"] )
                if error?["error"] == nil {
                    clousure(true)
                } else {
                    clousure(false)
                }
            case .failure:
                clousure(false)

            }
            
        }
    }
    
    func getInfo(comletition: @escaping (_ response: AFDataResponse<Any>)->Void) {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token
        ]
        
        AF.request(vkEndpoint + "/account.getInfo", parameters: parameters).responseJSON { response in
            print(response)
            //print(response["error"])
            comletition(response)
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
    
    func getFriend(completion: (([User]) -> Void)? = nil ) {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "user_id": Session.currentUser.userId,
            "fields": "nickname, photo_200_orig"
        ]
        AF.request(vkEndpoint + "/friends.get", parameters: parameters).responseData { response in
            if let data = response.value {
                do {
                    let users = try JSONDecoder().decode(VkResponse<User>.self, from: data).items
                    print(users)
                    Repository.realm.save(users)
                    completion?(users)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getPhotosAll(userId: Int, completion: (([Photo]) -> Void)? = nil ) {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "owner_id": userId,
            "extended": 1
        ]
        
        AF.request(vkEndpoint + "/photos.getAll", parameters: parameters).responseData { response in
            if let data = response.value {
                do {
                    let photos = try JSONDecoder().decode(VkResponse<Photo>.self, from: data).items
                    print(photos)
                    Repository.realm.save(photos)
                    completion?(photos)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getGroups(completion: (([Group]) -> Void)? = nil) {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "user_id": Session.currentUser.userId,
            "extended": 1
        ]
        
        AF.request(vkEndpoint + "/groups.get", parameters: parameters).responseData { response in
            if let data = response.value {
                do {
                    let groups = try JSONDecoder().decode(VkResponse<Group>.self, from: data).items
                    print(groups)
                    Repository.realm.save(groups)
                    completion?(groups)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func searchGroups(query: String, sort: Int = 0, completion: (([Group]) -> Void)? ) {
        let parameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "q": query,
            "sort": sort
        ]
        AF.request(vkEndpoint + "/groups.search", parameters: parameters).responseJSON { response in
            print(response)
        }
        
        AF.request(vkEndpoint + "/groups.search", parameters: parameters).responseData { response in
            if let data = response.value {
                do {
                    let groups = try JSONDecoder().decode(VkResponse<Group>.self, from: data).items
                    print(groups)
                    completion?(groups)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
}
