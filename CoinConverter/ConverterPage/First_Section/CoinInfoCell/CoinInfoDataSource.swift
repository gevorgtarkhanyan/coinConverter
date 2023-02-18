//
//  CoinInfoDataSource.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/4/19.
//

import UIKit

class CoinInfoDataSource {
    
    static func dataModel(_ coin: CoinModel) -> [CoinInfoDataModel] {
        var dataModel: [CoinInfoDataModel] = []
        dataModel.append(CoinInfoDataModel(key: "market_cap_usd",  value: coin.marketCapUsd.getString() + " $"))
        dataModel.append(CoinInfoDataModel(key: "price_usd",       value: coin.marketPriceUSD.getString() + " $"))
        dataModel.append(CoinInfoDataModel(key: "price_btc",       value: coin.marketPriceBTC.getString() + " BTC"))
        dataModel.append(CoinInfoDataModel(key: "last_updated",    value: coin.lastUpdated.getDateFromUnixTime()))
        
        return dataModel
    }
}
