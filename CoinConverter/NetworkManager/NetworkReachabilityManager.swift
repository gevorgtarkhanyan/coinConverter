//
//  NetworkReachabilityManager.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/27/20.
//

import Foundation
import Alamofire

class Connectivity {
    
    static let shared = Connectivity()
    
    func isConnectedToInternet() -> Bool {
       return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}
