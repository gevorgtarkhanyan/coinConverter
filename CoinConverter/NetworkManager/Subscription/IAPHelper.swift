//
//  IAPHelper.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 30.12.21.
//

import Foundation
import StoreKit

enum ReceiptURL: String {
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    case production = "https://buy.itunes.apple.com/verifyReceipt"
}

final class IAPHelper: NSObject {

    static let sharedInstance = IAPHelper()

    typealias ReceiptData = [String: String]
//    var completionHandler: (() -> Void)?
    var pandingInfo: PandingInfo?

    //MARK: - Receipt Validation
    // Check first by production URL, if failed check error code, if 21007,
    // means that your receipt is from sandbox environment, need to check with sandbox URL
    public func receiptValidation(completion: @escaping (PandingInfo?) -> Void) {
        guard let requestDictionary = getReceiptData() else { return }
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            if Reachability.isConnectedToNetwork {
                guard let validationProdURL = URL(string: ReceiptURL.production.rawValue) else {
                    completion(nil)
                    debugPrint("Error: No production URL")
                    return
                }
                let prodSession = URLSession(configuration: .default)
                var prodRequest = URLRequest(url: validationProdURL)
                prodRequest.httpMethod = "POST"
                prodRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                prodSession.uploadTask(with: prodRequest, from: requestData) { (data, response, error) in
                    guard let data = data, error == nil else {
                        completion(nil)
                        debugPrint("the upload task returned an error: \(String(describing: error))")
                        return
                    }
//                    UserDefaults.standard.setValue(data, forKey: UserDefaultsKeys.subscriptionData)
                    Defaults.save(data: data, key: .subscriptionData)
                    self.dataHandling(with: data, requestData: requestData, completion: completion)
                }.resume()
            } else {
                guard let data: Data = Defaults.load(key: .subscriptionData) else { return }
//                guard let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.subscriptionData) as? Data else { return }
                self.dataHandling(with: data, requestData: requestData, completion: completion)
            }
        } catch let error as NSError {
            completion(nil)
            debugPrint("json serialization failed with error: \(error)")
        }
    }

    //MARK: - Data Handling
    private func dataHandling(with data: Data, requestData: Data, completion: @escaping (PandingInfo?) -> Void) {
        do {
            guard let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                  let status = appReceiptJSON["status"] as? Int64 else {
                debugPrint("Failed to cast serialized JSON to Dictionary<String, AnyObject>")
                return
            }
            switch status {
            case 0: // receipt verified in Production
                self.updateSubscription(with: appReceiptJSON, completion: completion)
                
            case 21007: // Means that our receipt is from sandbox environment, need to validate it there instead
                self.sandBoxRequest(from: requestData, completion: completion)
                
            default:
                completion(nil)
                debugPrint("Receipt validation error:", status)
                
            }
        } catch let error as NSError {
            completion(nil)
            debugPrint("json serialization failed with error: \(error)")
        }
    }
    
    private func sandBoxDataHandling(data: Data, completion: @escaping (PandingInfo?) -> Void) {
        do {
            guard let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(nil)
                debugPrint("Failed to cast serialized JSON to Dictionary<String, AnyObject>")
                return
            }
            
            self.updateSubscription(with: appReceiptJSON, completion: completion)
        } catch let error as NSError {
            completion(nil)
            debugPrint("json serialization failed with error: \(error)")
        }
    }
    
    //MARK: - SandBox Request
    private func sandBoxRequest(from requestData: Data, completion: @escaping (PandingInfo?) -> Void) {
        if Reachability.isConnectedToNetwork {
            guard let validationSandboxURL = URL(string: ReceiptURL.sandbox.rawValue) else {
                completion(nil)
                debugPrint("Error: No sandbox URL")
                return
            }
            let sandboxSession = URLSession(configuration: .default)
            var sandboxRequest = URLRequest(url: validationSandboxURL)
            sandboxRequest.httpMethod = "POST"
            sandboxRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            sandboxSession.uploadTask(with: sandboxRequest, from: requestData) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(nil)
                    debugPrint("the upload task returned an error: \(String(describing: error))")
                    return
                }
//                UserDefaults.standard.setValue(data, forKey: UserDefaultsKeys.sandBoxSubscriptionData)
                Defaults.save(data: data, key: .sandBoxSubscriptionData)
                self.sandBoxDataHandling(data: data, completion: completion)
            }.resume()
        } else if let data: Data = Defaults.load(key: .sandBoxSubscriptionData) {
//        } else if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.sandBoxSubscriptionData) as? Data {
            sandBoxDataHandling(data: data, completion: completion)
        } else {
            completion(nil)
        }
    }
    
    //MARK: -Receipt Data
    private func getReceiptData() -> ReceiptData? {
        guard let receiptPath = Bundle.main.appStoreReceiptURL?.path, FileManager.default.fileExists(atPath: receiptPath),
              let appStoreURL = Bundle.main.appStoreReceiptURL else { return nil }
        
        var receiptData: NSData?
        do {
            receiptData = try NSData(contentsOf: appStoreURL, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            debugPrint("ERROR: " + error.localizedDescription)
        }
        
        guard let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn) else { return nil }
        let requestDictionary = ["receipt-data": base64encodedReceipt, "password": Constants.shareSecret]
        
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {
            debugPrint("requestDictionary is not valid JSON")
            return nil
        }
        
        return requestDictionary
    }
    
    //MARK: - Receipt Logic
    private func updateSubscription(with appReceiptJSON: NSDictionary, completion: @escaping (PandingInfo?) -> Void) {
        guard let pendingRenewalInfo = (appReceiptJSON["pending_renewal_info"] as? [NSDictionary])?.first else {
            Defaults.save(data: false, key: .subscribed)
            Defaults.removeObject(forKey: .subscriptionType)
            completion(self.pandingInfo)
            debugPrint("Failed to cast serialized JSON to Dictionary<String, AnyObject>")
            return
        }
        self.pandingInfo = PandingInfo(json: pendingRenewalInfo)
        if self.pandingInfo?.productId == Defaults.load(key: .subscriptionType) {
            if self.checkExpirationDate(jsonResponse: appReceiptJSON as NSDictionary) {
                Defaults.save(data: true, key: .subscribed)
                completion(self.pandingInfo)
            } else {
                Defaults.save(data: false, key: .subscribed)
                Defaults.removeObject(forKey: .subscriptionType)
                completion(self.pandingInfo)
            }
        } else {
            if self.checkExpirationDate(jsonResponse: appReceiptJSON as NSDictionary) {
                Defaults.save(data: self.pandingInfo?.productId, key: .subscriptionType)
                Defaults.save(data: true, key: .subscribed)
                completion(self.pandingInfo)
            } else {
                Defaults.save(data: false, key: .subscribed)
                Defaults.removeObject(forKey: .subscriptionType)
                completion(self.pandingInfo)
            }
        }
    }

//    private func checkExpirationDate(jsonResponse: NSDictionary) -> Bool {
//        guard let info: NSArray = jsonResponse["latest_receipt_info"] as? NSArray,
//              let last = info.firstObject as? NSDictionary,
//              let expireString = last["expires_date_ms"] as? String,
//              let expireMiliseconds = Double(expireString) else { return false }
//
//        let current = Date().timeIntervalSince1970 * 1000
//        let expire = TimeInterval(expireMiliseconds)
//        return expire > current
//    }
    
    private func checkExpirationDate(jsonResponse: NSDictionary) -> Bool {
        guard let info = jsonResponse["latest_receipt_info"] as? [NSDictionary] else { return false }
 
        let current = Date().timeIntervalSince1970 * 1000
        var mss = [Double]()

        for data in info {
            if let expireString = data["expires_date_ms"] as? String, let expireMiliseconds = Double(expireString) {
                mss.append(expireMiliseconds)
            }
        }

        return mss.contains(where: { $0 > current })
    }
    
}
