//
//  NetworkManager.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/24/19.
//

import UIKit
import Alamofire
import KeychainAccess

protocol NetworkManagerProtocol {
    func getAllCoins(success: @escaping([CoinModel]) -> Void, failer: @escaping(String) -> Void)
    func getCoin(coinID: String, success: @escaping(CoinModel) -> Void, failer: @escaping(String) -> Void)
    func getChart(coinId: String, period: String, success: @escaping([CoinGraphModel]) -> Void, failer: @escaping(String) -> Void)
    func getAllFiats(success: @escaping([FiatModel]) -> Void, failer: @escaping(String) -> Void)
    func sendDeviceInfo(ended: @escaping () -> Void)
    func addSubsriptionToServer(success: @escaping() -> Void, failer: @escaping(String) -> Void)
    func getSubscriptionFromServer(success: @escaping(SubscriptionModel) -> Void, failer: @escaping(String) -> Void)
}

class NetworkManager: NSObject, NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private override init() {}
    
    let receiptURL = Bundle.main.appStoreReceiptURL
    
    //MARK: -- Coin part of code
    func getAllCoins(success: @escaping ([CoinModel]) -> Void, failer: @escaping (String) -> Void) {
        AlamofireManager.shared.request(method: .get, endPoint: ConverterAPI.allCoinsAPI, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? [NSDictionary] {
                let coins = jsonData.map { CoinModel(json: $0) }
                success(coins)
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message)
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    func getExistedCoins(coinsIDs: [String], success: @escaping ([CoinModel]) -> Void, failer: @escaping (String) -> Void) {
        let endPoint = ConverterAPI.existedCoins
        
        let parameters = ["coinIds": coinsIDs]
                
        AlamofireManager.shared.request(method: .post, endPoint: endPoint, parameters: parameters, encoding: JSONEncoding.default, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? [NSDictionary] {
                let coins = jsonData.map { CoinModel(json: $0) }
                success(coins)
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message)
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    func getChart(coinId: String, period: String, success: @escaping ([CoinGraphModel]) -> Void, failer: @escaping (String) -> Void) {
        var endPoint = ConverterAPI.chartAPI
        endPoint = endPoint.replacingOccurrences(of: "coin_id", with: "\(coinId)")
        endPoint = endPoint.replacingOccurrences(of: "time_period", with: "\(period)")
        
        AlamofireManager.shared.request(method: .get, endPoint: endPoint, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? [NSDictionary] {
                let filteredData = jsonData.filter { (item) -> Bool in
                    if let _ = item.value(forKey: "date") as? Double, let _ = item.value(forKey: "usd") as? Double, let _ = item.value(forKey: "btc") as? Double {
                        return true
                    }
                    return false
                }
                
                let graphData = filteredData.map {CoinGraphModel(date: $0["date"] as! Double, usd: $0["usd"] as! Double)}
                success(graphData)
            } else {
                let message = json["description"] as? String ?? Messages.unknownError
                failer(message)
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    func getCoin(coinID: String = Constants.mainCoinID, success: @escaping (CoinModel) -> Void, failer: @escaping (String) -> Void) {
        var endPoint = ConverterAPI.existedCoins
        endPoint = endPoint.replacingOccurrences(of: "coin_id", with: "\(coinID)")
        
        AlamofireManager.shared.request(method: .get, endPoint: endPoint, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let jsonData = json["data"] as? NSDictionary {
                let coin = CoinModel(json: jsonData)
                success(coin)
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message)
            }

        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    func getCoinList(skip: Int = 0, short: Bool, searchText: String? = nil, success: @escaping([CoinModel], Int) -> Void, failer: @escaping(String) -> Void) {
        var parametrs: [String: Any] = ["skip": skip, "limit": Constants.limit, "short": short]
        if let searchText = searchText {
            parametrs["search"] = searchText
        }
        
        AlamofireManager.shared.request(method: .get, endPoint: ConverterAPI.allCoinsAPI, parameters: parametrs, success: { (json) in
            guard let status = json.value(forKey: "status") as? Int, status == 0,
                  let data = json.value(forKey: "data") as? NSDictionary,
                  let result = data.value(forKey: "results") as? [NSDictionary],
                  let count = data.value(forKey: "count") as? Int else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message)
                return
            }
            
            let coins = result.map { CoinModel(json: $0) }
            success(coins, count)
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    
    //MARK: -- Fiat part of code
    func getAllFiats(success: @escaping ([FiatModel]) -> Void, failer: @escaping (String) -> Void) {
        let deviceUUID = generateDeviceUid()
//        var rateList: [FiatModel] = []
        var endPoint = ConverterAPI.fiatAPI
        
        endPoint = endPoint.replacingOccurrences(of: "u_id", with: "\(deviceUUID)")
        
        AlamofireManager.shared.request(method: .get, endPoint: endPoint, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0,
               let data = (json["data"] as? [NSDictionary]) {
//                for rate in data {
//                    rateList.append(FiatModel(json: rate))
//                }
                success(data.map { FiatModel(json: $0) })
            } else {
                let message = json["description"] as? String ?? "unknown_error"
                failer(message)
                debugPrint(message)
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
    
    // MARK: -- Send device data to server
    func sendDeviceInfo(ended: @escaping () -> Void) {
        let deviceUUID = generateDeviceUid()
        debugPrint("UUID --- \(deviceUUID)")
        
        let osVersion = UIDevice.current.systemVersion
        var appVersion = Messages.unknownAppVersion
        
        if let info = Bundle.main.infoDictionary, let shortVersion = info["CFBundleShortVersionString"] as? String {
            appVersion = shortVersion
        }
        
        let parameters = ["deviceModel": UIDevice.modelName,
                          "appVersion": appVersion,
                          "deviceType": "1",
                          "OSVersion": osVersion] as [String: String]
        
        let endPoint = "user/\(deviceUUID)/info"
        
        AlamofireManager.shared.request(method: .post, secure: true, endPoint: endPoint, parameters: parameters, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0 {
                debugPrint("Device info sended: \(json)")
                debugPrint("Parameters --- \(parameters)")
                ended()
            } else {
                let message = (json["description"] as? String ?? "Unknown error")
                debugPrint("Device send error --- \(message)")
                ended()
            }
        }) { (error) in
            ended()
            debugPrint(error)
        }
    }
    
    // MARK: -- Subscription send/get from/to server
    func addSubsriptionToServer(success: @escaping() -> Void, failer: @escaping(String) -> Void) {
        let uID = getDeviceUid()
        var endPoint = ConverterAPI.subscriptionAddAPI
        endPoint = endPoint.replacingOccurrences(of: "u_id", with: "\(uID)")
        
        let decodedData = getAppStoreData() != nil ? getAppStoreData()! : ""
        let subscriptionId = Bundle.main.bundleIdentifier ?? ""
        let parameters = ["subscriptionId": subscriptionId, "purchaseToken": decodedData]
        
        AlamofireManager.shared.request(method: .post, endPoint: endPoint, parameters: parameters, encoding: AppstoreEncoding(), success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0 {
//                UserDefaults.standard.set(false, forKey: DefaultCases.subscribed.rawValue)
                UserDefaults.standard.set(true, forKey: DefaultCases.subscriptionSendFiled.rawValue)
                success()
                debugPrint("SubscriptionPost Success ----")
            } else {
                UserDefaults.standard.set(true, forKey: DefaultCases.subscriptionSendFiled.rawValue)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//                    self.addSubsriptionToServer(success: success)
//                })
                failer("SubscriptionPost Error_1 ----")
            }
        }) { (error) in
            failer(error)
            UserDefaults.standard.set(true, forKey: DefaultCases.subscriptionSendFiled.rawValue)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//                self.addSubsriptionToServer(success: success)
//            })
            
            debugPrint("SubscriptionPost Error_2 --- \(error)")
        }
    }

    func getSubscriptionFromServer(success: @escaping(SubscriptionModel) -> Void, failer: @escaping(String) -> Void) {
        let uID = getDeviceUid()
        var endPoint = ConverterAPI.subscriptionGetAPI
        endPoint = endPoint.replacingOccurrences(of: "u_id", with: "\(uID)")
        
        AlamofireManager.shared.request(method: .get, secure: true, endPoint: endPoint, success: { (json) in
            if let status = json.value(forKey: "status") as? Int, status == 0, let data = json["data"] as? NSDictionary {
                let subscription = SubscriptionModel(json: data)
                subscription.saveCacher()
                success(subscription)
            } else {
                let message = (json["description"] as? String ?? "Unknown error")
                failer(message)
            }
        }) { (error) in
            failer(error)
            debugPrint(error)
        }
    }
   
    // MARK: -- Device UUID save in keychain
    private func getDeviceUid() -> String {
        if let uuid = UserDefaults.standard.object(forKey: Constants.deviceID) as? String {
              return uuid
          }

          let keychain = Keychain(service: Constants.appGroupName)
          do {
              let token = try keychain.getString(Constants.deviceID)
              if let tkn = token {
                  UserDefaults.standard.set(token, forKey: Constants.deviceID)
                  return tkn
              } else {
                  return self.generateDeviceUid()
              }
          } catch {
            debugPrint(Messages.uidNotFound)
              return self.generateDeviceUid()
          }
      }

      private func generateDeviceUid() -> String {
          let keychain = Keychain(service: Constants.appGroupName)
          let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "nil"
          UserDefaults.standard.set(uuid, forKey: Constants.deviceID)
          keychain[Constants.deviceID] = uuid
          return uuid
      }
    
    private func getAppStoreData() -> String? {
        if let receiptURL = Constants.receiptURL {
            if let receipt = try? Data(contentsOf: receiptURL) {
                // Get appstore data
                let base64encodedReceipt = receipt.base64EncodedString()
                var decodedData = String(base64encodedReceipt.filter { " \n\t\r".contains($0) == false })
                decodedData = decodedData.replacingOccurrences(of: "+", with: "%2B")
                return decodedData
            } else {
                debugPrint(Messages.subscriptInfoEmpty)
            }
        } else {
            debugPrint(Messages.appStoreURLNotFound)
        }
        return nil
    }
}

//MARK: -- For setting default value protocol function argument
extension NetworkManagerProtocol {
    func getCoin(coinID: String = Constants.mainCoinID, success: @escaping(CoinModel) -> Void, failer: @escaping(String) -> Void) {}
}

