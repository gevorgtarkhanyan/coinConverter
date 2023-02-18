//
//  NewsManager.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 24.12.21.
//

import Foundation
import Alamofire
import KeychainAccess


class NewsManager {
    
    static let shared = NewsManager()
        
    private init(){}
    
    func getNews(searchText: String?,skip: Int = 0,tab: Int,success: @escaping([NewsModel], Int) -> Void, failer: @escaping(String) -> Void) {
        
        var params = ["tab": "\(tab)","skip": "\(skip)", "limit": Constants.newslimit] as [String : Any]
        
        if let searchText = searchText {
            params["search"] = searchText
        }
        
        let deviceUUID = generateDeviceUid()

        let endPoint = "news/\(deviceUUID)/list"
        
        AlamofireManager.shared.request(method: .get, endPoint: endPoint, parameters: params) { json in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? [String: Any],
               let result = jsonData["results"] as? [NSDictionary]{
                
                let count = jsonData["count"] as? Int ?? 0
                let news = result.map { NewsModel(json: $0) }
                success(news,count)
         
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message.localized())
            }
        } failure: { error in
            failer(error)
            debugPrint(error)
        }
    }
    
    public func putLikeToBackend( userActionType: UserAction, userAction: Double, _id: String, success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        
        let deviceUUID = generateDeviceUid()
        
        var endPoint = "news/\(_id)/\(deviceUUID)/"
        
        switch userActionType {
        case .like:
            endPoint +=  UserAction.like.rawValue
        case .unlike:
            endPoint +=  UserAction.unlike.rawValue
        }
        
        let param = ["userAction" : userAction]
        
        AlamofireManager.shared.request(method: .put, endPoint: endPoint, parameters: param, encoding: URLEncoding.queryString, success: { _ in
            success()
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    public func putBookmarkState( isBookmarked: Bool, _id: String, success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        
        let deviceUUID = generateDeviceUid()

        let endPoint = "news/\(_id)/\(deviceUUID)" + (isBookmarked ? "/unbookmark" :  "/bookmark")
        
        AlamofireManager.shared.request(method: .put, endPoint: endPoint, success: { _ in
            success()
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    public func getSources( success: @escaping(SourceModel) -> Void, failer: @escaping(String) -> Void) {
        let deviceUUID = generateDeviceUid()

        let endPoint = "news/\(deviceUUID)/sources"
        
        AlamofireManager.shared.request(method: .get, endPoint: endPoint, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? NSDictionary {
                
                let sources = SourceModel(json: jsonData)
                success(sources)
         
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message.localized())
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    public func addSource( source: String, success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        
        let param = ["source" : source]
        
        let deviceUUID = generateDeviceUid()

        let endPoint = "news/\(deviceUUID)/addSource"

        AlamofireManager.shared.request(method: .put, endPoint: endPoint, parameters: param, encoding: URLEncoding.queryString, success: { _ in
            success()
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    public func removeSource( source: String,  success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        
        let param = ["source" : source]
        
        let deviceUUID = generateDeviceUid()

        let endPoint = "news/\(deviceUUID)/removeSource"

        AlamofireManager.shared.request(method: .put, endPoint: endPoint, parameters: param, encoding: URLEncoding.queryString, success: { _ in
            success()
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    public func getNewsDetail(newsId: String,  success: @escaping(NewsModel) -> Void, failer: @escaping(String) -> Void) {
        
        let endPoint = "api/news/" + newsId
        
        AlamofireManager.shared.requestNews(method: .get, endPoint: endPoint , success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? NSDictionary
               {
                let news =  NewsModel(json: jsonData)
                success(news)
         
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message.localized())
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    public func patchNewsViews( _id: String, success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        
        let endPoint = "news/" + _id + "/watched"
        
        AlamofireManager.shared.request(method: .patch, endPoint: endPoint, success: { _ in
            success()
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    private func generateDeviceUid() -> String {
        let keychain = Keychain(service: Constants.appGroupName)
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "nil"
        UserDefaults.standard.set(uuid, forKey: Constants.deviceID)
        keychain[Constants.deviceID] = uuid
        return uuid
    }
}

//Helper

enum UserAction: String {
    case like
    case unlike
}

