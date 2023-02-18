//
//  ChartDataSource.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/19/19.
//

import Foundation

class ChartDataSource {
    
    static func getChartData(for coin: CoinModel) -> [ChartModel] {
        var data: [ChartModel] = []
        
        data.append(ChartModel(key: "Rank", value: String(coin.rank)))
        data.append(ChartModel(key: "Market cap USD", value: coin.marketCapUsd.getString()))
        data.append(ChartModel(key: "Price USD", value: coin.marketPriceUSD.getString()))
        data.append(ChartModel(key: "Price BTC", value: coin.marketPriceBTC.getString()))
        data.append(ChartModel(key: "Last updated", value: coin.lastUpdated.getDateFromUnixTime()))
        data.append(ChartModel(key: "Change 1 hour", value: coin.change1h.getString()))
        data.append(ChartModel(key: "Change 24 hour", value: coin.change24h.getString()))
        data.append(ChartModel(key: "Change 1 week", value: coin.change7d.getString()))
        
        return data
    }
    
}
