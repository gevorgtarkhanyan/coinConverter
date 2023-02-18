//
//  Cacher.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 06.08.21.
//

import Foundation

class Cacher {
    
    static let shared = Cacher()
    
    public var subscriptionModel: SubscriptionModel?
    public var allCoins = [CoinModel]()
}
