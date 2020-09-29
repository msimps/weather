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
import PromiseKit

class VkApi {
    let vkEndpoint = "https://api.vk.com/method"
    let apiVersion = "5.52"
    
    
    func getNewsfeed(parameters: [String: Any] = [:] ,completion: ((VkNewsfeed) -> Void)? = nil) {
        var defaultParameters: Parameters = [
            "v": apiVersion ,
            "access_token": Session.currentUser.token,
            "filters": "post, wall_photo"
        ]
        
        defaultParameters.merge(parameters){ (current, _) in current }
        
        /*AF.request(vkEndpoint + "/newsfeed.get", parameters: parameters).responseJSON { response in
            print(response)
        }*/
        
        AF.request(vkEndpoint + "/newsfeed.get", parameters: defaultParameters).responseData { response in
        
            if let data = response.value {
    
                var newsfeed = VkNewsfeed()
                
                let dispatchGroup = DispatchGroup()
                
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    let users = try? JSONDecoder().decode(VkFeedUsersResponse.self, from: data).items
                    users?.forEach { newsfeed.users[$0.id] = $0 }
                }
                
                DispatchQueue.global().async(group: dispatchGroup) {
                   let groups = try? JSONDecoder().decode(VkFeedGroupsResponse.self, from: data).items
                    groups?.forEach { newsfeed.groups[$0.id] = $0 }
               }
                
                
                DispatchQueue.global().async(group: dispatchGroup){
                    let response = try? JSONDecoder().decode(VkResponse<Post>.self, from: data)
                    newsfeed.posts = response?.items ?? []
                    newsfeed.next_from = response?.next_from ?? ""
                }
        
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    //print(newsfeed)
                    completion?(newsfeed)
                }

            } 
        }
    }
    
    
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
                //print(error?["error"] )
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
        
        //AF.request(vkEndpoint + "/friends.get", parameters: parameters).responseDecodable(VkResponse<User>.self)
        firstly {
            promiseRequest(parameters: parameters, url: vkEndpoint + "/friends.get")
        }
            .map{ data in
                return  try JSONDecoder().decode(VkResponse<User>.self, from: data).items
        }
            .tap {
                print($0)
        }
            .get { users in
                Repository.realm.save(users)
        }
            .done{ users in
                completion?(users)
        }
            .catch{ error in
                print(error)
        }
        
    }
    
    func promiseRequest(parameters: Parameters, url: String ) -> Promise<Data>{
        
        return Promise { resolver in
            AF.request(url, parameters: parameters).responseData { response in
                if let data = response.value {
                    resolver.fulfill(data)
                } else {
                    resolver.reject(response.error as! Error)
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
        
        let request = AF.request(vkEndpoint + "/groups.get", parameters: parameters)
        
        let opq = OperationQueue()
        
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        opq.addOperation(parseData)
        
        let saveToRealm = SaveToRealm(completion);
        saveToRealm.addDependency(parseData)
        OperationQueue.main.addOperation(saveToRealm)
        
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


class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    override func cancel() {
        super.cancel()
        state = .finished
    }
}


class GetDataOperation: AsyncOperation{
    private var request: DataRequest
    var data: Data?
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func cancel(){
        request.cancel()
        super.cancel()
    }
    
    override func main(){
        request.responseData { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
}

class ParseData: Operation{
    var outputData: [Group]? = []
    
    override func main() {
        guard
            let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        do {
            outputData = try JSONDecoder().decode(VkResponse<Group>.self, from: data).items
        } catch {
            print(error)
        }
    }
}

class SaveToRealm: Operation{
    var completion: (([Group]) -> Void)? = nil
    
    override func main() {
        guard
            let parseData = dependencies.first as? ParseData,
            let groups = parseData.outputData else { return }
        Repository.realm.save(groups)
        completion?(groups)
    }
    
    init(_ completion: (([Group]) -> Void)?){
        self.completion = completion
    }
}

