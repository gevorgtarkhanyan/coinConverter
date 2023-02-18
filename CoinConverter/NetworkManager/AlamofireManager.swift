//
//  Alamofire.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/24/19.
//

import Foundation
import Alamofire

class AlamofireManager: NSObject {
    
    static let shared = AlamofireManager()
    
    private lazy var alamofireSessionManager: SessionManager? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constants.requestTimeOut
        configuration.timeoutIntervalForResource = Constants.requestTimeOut
        
        let trust = ServerTrustPolicyManager(policies: [
            "173.255.240.136": ServerTrustPolicy.disableEvaluation,
            "45.79.84.245": ServerTrustPolicy.disableEvaluation
        ])
        
        let manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: trust)
        manager.retrier = Retrier()
        return manager
    }()
    
    func request(method: HTTPMethod, secure: Bool = false, endPoint: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, success: @escaping(NSDictionary) -> Void, failure: @escaping(String) -> Void) {
        let url = secure ? URL(string: Constants.HttpsUrl + endPoint)! : URL(string: Constants.HttpUrl + endPoint)!
        print("url:  ", url)
        alamofireSessionManager?.request(url, method: method, parameters: parameters, encoding: encoding).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let value):
                if let dictionary = value as? NSDictionary {
                    success(dictionary)
                } else {
                    failure("Data is not JSON")
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestForCoinzila(method: HTTPMethod, secure: Bool = false, endpoint: String, params: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, success: @escaping(NSDictionary) -> Void, failure: @escaping(String) -> Void) {
        
        let url = URL(string: Constants.HttpsCoinzilla + endpoint)!
        
        alamofireSessionManager?.request(url, method: method, parameters: params, encoding: encoding).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let value):
                guard let dictionary = value as? NSDictionary else {
                    failure("Data is not JSON")
                    return
                }
                success(dictionary)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestNews(method: HTTPMethod, secure: Bool = false, endPoint: String,params: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, success: @escaping(NSDictionary) -> Void, failure: @escaping(String) -> Void) {
        
        let url = URL(string: Constants.HttpNewsUrl + endPoint)!

        alamofireSessionManager?.request(url, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let value):
                if let dictionary = value as? NSDictionary { success(dictionary) }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func request(method: HTTPMethod, url: URL) {
        alamofireSessionManager?.request(url, method: method, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func cancelTask(urlPath: String) {
        alamofireSessionManager?.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach {
                let urlString = "\(String(describing: $0.originalRequest?.url))"
                if urlString.contains(urlPath) {
                    $0.cancel()
                }
            }
            uploadData.forEach {
                let urlString = "\(String(describing: $0.originalRequest?.url))"
                if urlString.contains(urlPath) {
                    $0.cancel()
                }
            }
            downloadData.forEach {
                let urlString = "\(String(describing: $0.originalRequest?.url))"
                if urlString.contains(urlPath) {
                    $0.cancel()
                }
            }
        }
    }
    
}

// MARK: - Helpers
struct AppstoreEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        let bodyString = parameters?.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
        request.httpBody = bodyString?.data(using: String.Encoding.utf8)
        return request
    }
}

struct Retrier: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if error.localizedDescription.lowercased().contains("network connection was lost") {
            completion(true, 0.1)
            return
        }
        completion(false, 0.0)
    }
}
