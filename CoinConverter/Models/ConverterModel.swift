//
//  ConverterModel.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 25.06.21.
//

import Foundation

class ConverterModel {
    let headerCoin: CoinModel
    let headerFiat: FiatModel
    let addedCoins: [CoinModel]
    let addedFiats: [FiatModel]
    var allCoins: [CoinModel]
    let allFiats: [FiatModel]
    let reversed: Bool
    
    init(headerCoin: CoinModel, headerFiat: FiatModel, addedCoins: [CoinModel], addedFiats: [FiatModel], allCoins: [CoinModel], allFiats: [FiatModel], reversed: Bool) {
        self.headerCoin = headerCoin
        self.headerFiat = headerFiat
        self.addedCoins = addedCoins
        self.addedFiats = addedFiats
        self.allCoins = allCoins
        self.allFiats = allFiats
        self.reversed = reversed
    }
    
    init() {
        self.headerCoin = CoinModel()
        self.headerFiat = FiatModel()
        self.addedCoins = [CoinModel]()
        self.addedFiats = [FiatModel]()
        self.allCoins = [CoinModel]()
        self.allFiats = [FiatModel]()
        self.reversed = false
    }
    
    func saveForOfflineMode() {
        
    }
    
    func saveForOnlineMode() {
        
    }
}
