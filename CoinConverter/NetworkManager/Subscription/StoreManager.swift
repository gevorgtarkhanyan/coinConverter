//
//  StoreManager.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/17/20.
//

import StoreKit
import Foundation

protocol StoreManagerDelegate: AnyObject {
    func storeManagerDidReceiveResponse(_ products: [Subscription])
    func productRequestError(_ message: String)
}

class StoreManager: NSObject {
    
    static let shared = StoreManager()
    
    weak var delegate: StoreManagerDelegate?

    /// Keeps a strong reference to the product request.
    private var productRequest: SKProductsRequest!
//    private(set) var skProduct: SKProduct?
//    private(set) var products: [Subscription]?
    
    
    private var productIDs: Set<String> {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let productIds = [".monthly", ".yearly"]
        return Set(productIds.map { bundleId + $0 })
    }

    /// Fetches information about your products from the App Store.
    public func startProductRequest() {
        productRequest = SKProductsRequest(productIdentifiers: productIDs)
        productRequest.delegate = self
        productRequest.start()
    }
    
}

// MARK: - SKProductsRequestDelegate methods
extension StoreManager: SKProductsRequestDelegate {
    /// Used to get the App Store's response to your request and notify your observer.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products.map { Subscription(product: $0) }
        
        Defaults.saveDefaults(data: products.first?.product.priceLocale, key: .subscriptrionLocale)
        Defaults.save(data: products.first?.price, key: .productPriceMonthly)
        Defaults.save(data: products.last?.price, key: .productPriceYearly)
        self.delegate?.storeManagerDidReceiveResponse(products)
    }
}

// MARK: - SKRequestDelegate methods
extension StoreManager: SKRequestDelegate {
    /// Called when the product request failed.
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.productRequestError(error.localizedDescription)
        }
    }
}

