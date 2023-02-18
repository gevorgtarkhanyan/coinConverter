//
//  SKProduct_Extension.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/17/20.
//

import Foundation
import UIKit
import StoreKit

extension SKProduct {
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
