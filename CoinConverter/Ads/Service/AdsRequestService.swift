//
//  AdsRequestService.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.07.21.
//

import Foundation



import UIKit

//must be modifiing
enum AdsEndPointEnum: String, CaseIterable {
    case converter = "95260a4cafeebc8f751"
}

class AdsRequestService {
    // MARK: - Properties
    
    static let shared = AdsRequestService()
    
    // MARK: - Endpoints
    
    fileprivate let getZoneIds = "adverts/list"
    

    
    // MARK: - Requests
    
    func getZoneIdsList(success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        AlamofireManager.shared.request(method: .get, endPoint: getZoneIds) { (json) in
            guard let status = json.value(forKey: "status") as? Int, status == 0, let data = json["data"] as? [NSDictionary] else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message)
                return
            }
            ZoneIdsManager.shared.removeAdsZoneByFolder()

            for item in data {
                ZoneIdsManager.shared.addZoneIdToFile(ZoneIdModel(json: item))
            }
            success()
        } failure: { (error) in
            failer(error)
            debugPrint(error)
        }
    }

    func getAdsFromServer(success: @escaping(AdsModel) -> Void, zoneId: String, zoneName: String, failer: @escaping(String) -> Void) {
        
        let endpoint = "adverts/params/\(zoneId)/\(zoneName)"
        
        AlamofireManager.shared.cancelTask(urlPath: "adverts/params")
        AlamofireManager.shared.cancelTask(urlPath: Constants.HttpsCoinzilla)
        
        AlamofireManager.shared.request(method: .get, endPoint: endpoint, success: { (json) in
            
             guard let data = json["data"] as? NSDictionary else {
                 let message = json["description"] as? String ?? "unknown_error"
                 failer(message.localized())
                 return
             }
             let adse = AdsModel(jsonFromServer: data)
             success(adse)
         }) { (error) in
             failer(error)
             debugPrint(error)
         }
     }
    
    func getAdsFromCoinzila(success: @escaping(AdsModel) -> Void, endpoint: String, failer: @escaping(String) -> Void) {
        
        AlamofireManager.shared.cancelTask(urlPath: "adverts/params")
        AlamofireManager.shared.cancelTask(urlPath: Constants.HttpsCoinzilla)
        
        AlamofireManager.shared.requestForCoinzila(method: .get, endpoint: endpoint, success: { (json) in
            
             guard let data = json["ad"] as? NSDictionary else {
                 let message = json["description"] as? String ?? "unknown_error"
                 failer(message.localized())
                 return
             }
             let adse = AdsModel(json: data)
             success(adse)
         }) { (error) in
             failer(error)
             debugPrint(error)
         }
     }
    
    func putAdsTrackForServer(zoneId: String, adsId: String, click: Int = 0, imp: Int = 0 ) {
        let endpoint = "adverts/\(adsId)/\(zoneId)/updateStats"
        let params = ["click": "\(click)", "imp": "\(imp)", "deviceType": "\(1)"]
        
        AlamofireManager.shared.request(method: .put, endPoint: endpoint, parameters: params, success: { _ in
            debugPrint("Ads Track Success")
        }) { (error) in
            debugPrint(error)
        }
    }
    
    func postForCoinzileInpression(url: String) {
        guard let url = URL(string: url) else { return }
        AlamofireManager.shared.request(method: .post, url: url)
    }
    
}
