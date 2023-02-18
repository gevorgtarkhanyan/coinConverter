//
//  CoinGraphModel.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/24/19.
//

import UIKit

class CoinGraphModel: Codable {
    let date: Double
    let usd: Double

    init(date: Double, usd: Double) {
        self.date = date
        self.usd = usd
    }
}
