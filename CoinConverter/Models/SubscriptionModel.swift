//
//  SubscriptionModel.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/16/20.
//

import Foundation
import StoreKit
import RealmSwift

class SubscriptionModel: NSObject, Codable {
    var isPromo: Bool
    var maxCoinsCount: Int
    var maxFiatsCount: Int
    
    init(json: NSDictionary) {
        self.isPromo = json.value(forKey: "isPromo") as? Bool ?? false
        self.maxCoinsCount = json.value(forKey: "maxCoinsCount") as? Int ?? 0
        self.maxFiatsCount = json.value(forKey: "maxFiatsCount") as? Int ?? 0
        super.init()
    }
    
    func saveCacher() {
        Cacher.shared.subscriptionModel = self
    }
}

class Subscription {
    var product: SKProduct = SKProduct()
    var formattedPrice: String = ""
    var price: Double = 0
    
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
//        formatter.formatterBehavior = .behavior10_4
        return formatter
    }()

    init(product: SKProduct) {
        self.product = product
        
        if formatter.locale != self.product.priceLocale {
            formatter.locale = self.product.priceLocale
        }
        formattedPrice = formatter.string(from: product.price) ?? "\(product.price)"
        price = Double(truncating: product.price)
    }
}

class LatestInfo {
    let productId: String
    let expireDate: Double

    init(json: NSDictionary) {
        self.productId = json.value(forKey: "product_id") as? String ?? ""
        self.expireDate = Double(json.value(forKey: "expires_date_ms") as? String ?? "0")! / 1000
    }
}

class PandingInfo {
    let productId: String
    let autoRenewId: String
    
    init(json: NSDictionary) {
        self.productId = json.value(forKey: "product_id") as? String ?? ""
        self.autoRenewId = json.value(forKey: "auto_renew_product_id") as? String ?? ""
    }
}
