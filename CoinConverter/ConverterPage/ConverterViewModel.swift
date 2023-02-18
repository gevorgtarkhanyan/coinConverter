//
//  ConverterViewModel.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 14.02.22.
//

import Foundation
import UIKit

protocol ConverterViewModelDelegate: AnyObject {
    func reloadData()
    func requestFailed(with error: String)
    func startLoading()
    func endLoading()
}

class ConverterViewModel: NSObject {
    
    public var reversed = false
    
    public var infoCoinData: [CoinInfoDataModel]? {
        guard let coin = headerCoin else { return nil }
        return CoinInfoDataSource.dataModel(coin)
    }
    
    public var headerCoin: CoinModel?
    public var headerFiat: FiatModel!
    
    public var allFiats: [FiatModel] = []
    
    public var existedCoins: [CoinModel] = []
    public var addedCoins: [CoinModel] = []
    public var addedFiats: [FiatModel] = []
    
    private var error: String?
    
    public var adsId: String = ""
    public var adsZoneId: String = ""
    
    private var multiplier: Double = 1
    private var saveSubscribed = false
        
    weak var delegate: ConverterViewModelDelegate?
    
    public var existedCoinsIDs: [String] {
        var existedCoinsIDs: [String] = []
        
        existedCoinsIDs = addedCoins.map { $0.coinId }
        if let headerCoin = headerCoin, !(addedCoins.contains { $0.coinId == headerCoin.coinId }) {
            existedCoinsIDs.append(headerCoin.coinId)
        }
        return existedCoinsIDs
    }
    
    public var addedCoinIDs: [String] {
        return addedCoins.map { $0.coinId }
    }
    
    public var addedFiatCurrencys: [String] {
        return addedFiats.map { $0.currency }
    }
    
    private var freeCoinsCount: Int {
        return subscribed ? 50 : 2//Cacher.shared.subscriptionModel?.maxCoinsCount ?? 2
    }
    
    private var freeFiatsCount: Int {
        return subscribed ? 50 : 2//Cacher.shared.subscriptionModel?.maxFiatsCount ?? 2
    }
    
    public var subscriptionChanged: Bool {
        return saveSubscribed != subscribed
    }
    
    //setup
    public func setup() {
        saveSubscribed = subscribed
        downloadCriptoData()
        AppRateManager.shared.setupRateApp()
        IAPHelper.sharedInstance.receiptValidation { _ in }
    }

    // MARK: -- Update all data
    public func getExistedCoins(with existedCoinsIDs: [String]? = nil) {
        saveSubscribed = subscribed
        let ids = existedCoinsIDs ?? self.existedCoinsIDs
        delegate?.startLoading()
        NetworkManager.shared.getExistedCoins(coinsIDs: ids, success: { (coins) in
            self.existedCoins = coins
            self.getState()
            self.delegate?.endLoading()
        }) { (error) in
            self.delegate?.requestFailed(with: error)
            debugPrint(error)
        }
    }
    
    // MARK: - Converter logic
    private func convertCoin(headerCoin: CoinModel, in coins: [CoinModel], into fiats: [FiatModel], with count: Double = 1) {
        let headerPriceUSD = headerCoin.marketPriceUSD
        let headerPriceBTC = headerCoin.marketPriceBTC
        
        for coin in coins {
            let coinPriceBTC = coin.marketPriceBTC
            
            let coinBTCValue = (headerPriceBTC / coinPriceBTC) * count
            coin.changeAblePrice = coinBTCValue
        }
        
        for fiat in fiats {
            let fiatPriceUSD = fiat.price
            
            let fiatPriceValue = headerPriceUSD * fiatPriceUSD * count
            fiat.changeAblePrice = fiatPriceValue
        }
        
        delegate?.reloadData()
    }
    
    private func convertFiat(headerFiat: FiatModel, in fiats: [FiatModel], into coins: [CoinModel], with count: Double = 1, for tableView: BaseTableView? = nil) {
        let headerPriceUSD = headerFiat.price
        
        for coin in coins {
            let coinPriceUSD = coin.marketPriceUSD
            
            let coinUSDValue = count / (headerPriceUSD * coinPriceUSD)
            coin.changeAblePrice = coinUSDValue
        }
        
        for fiat in fiats {
            let fiatPriceUSD = fiat.price
            
            let fiatPriceValue = (fiatPriceUSD / headerPriceUSD) * count
            fiat.changeAblePrice = fiatPriceValue
        }
        
        delegate?.reloadData()
    }
    
    func convertAfterAddingCripto(count: Double? = nil) {
        if count != nil {
            multiplier = count!
        }
        if reversed {
            if headerFiat != nil {
                convertFiat(headerFiat: headerFiat!, in: addedFiats, into: addedCoins, with: multiplier)
            }
        } else {
            if headerCoin != nil {
                convertCoin(headerCoin: headerCoin!, in: addedCoins, into: addedFiats, with: multiplier)
            }
        }
    }

    //MARK: - Page state
    private func saveState() {
        let headerFiatExistInTheList = addedFiats.contains(where: { $0.currency == headerFiat?.currency })
        let headerCoinExistInTheList = addedCoins.contains(where: { $0.coinId == headerCoin?.coinId })
        
        let fiatCurrencys = headerFiatExistInTheList ?
            addedFiats.map({ $0.currency }) :
            addedFiats.map({ $0.currency }) + [headerFiat?.currency]
        
        let coinIds = headerCoinExistInTheList ?
            addedCoins.map({ $0.coinId }) :
            addedCoins.map({ $0.coinId }) + [headerCoin?.coinId]
        
        let coinsForWidget = addedCoins.map({CoinModelForWidgetSetting(coinId: $0.coinId, name: $0.name)})
        
        Defaults.save(data: headerCoin?.coinId,       key: .converterHeaderCoinId)
        Defaults.save(data: headerFiat?.currency,     key: .converterHeaderFiatCurrency)
        Defaults.save(data: headerFiatExistInTheList, key: .headerFiatExistInTheList)
        Defaults.save(data: headerCoinExistInTheList, key: .headerCoinExistInTheList)
        Defaults.saveDefaults(data: fiatCurrencys,    key: .existedFiatCurrencys)
        Defaults.saveDefaults(data: coinIds,          key: .existedCoinsIDs)
        Defaults.saveDefaults(data: coinsForWidget,   key: .existedCoinsForWidgetSetting)
    }
    
    private func getState() {
        reversed                       =  Defaults.load(key: .converterReversed)             ?? false
        multiplier                     =  Defaults.load(key: .multiplier)                    ?? 1.0

        updateFiats()
        updateCoins()
        checkSubscription()
        convertAfterAddingCripto()
    }
    
    //state helpers
    private func updateFiats() {
        let headerFiatCurrency: String =  Defaults.load(key: .converterHeaderFiatCurrency)   ?? "USD"
        let fiatCurrencys: [String]    =  Defaults.loadDefaults(key: .existedFiatCurrencys)  ?? ["USD"]
        let headerFiatExistInTheList   =  Defaults.load(key: .headerFiatExistInTheList)      ?? true
        
        addedFiats.removeAll()
        headerFiat = allFiats.first(where: { $0.currency == headerFiatCurrency })
        for fiatCurrency in fiatCurrencys {
            if (fiatCurrency == headerFiat?.currency) && !headerFiatExistInTheList {
                continue
            } else {
                if let fiat = allFiats.first(where: { $0.currency == fiatCurrency }) {
                    addedFiats.append(fiat)
                }
            }
        }
    }
    
    private func updateCoins() {
        let headerCoinId: String       =  Defaults.load(key: .converterHeaderCoinId)         ?? "bitcoin"
        let coinIds: [String]          =  Defaults.loadDefaults(key: .existedCoinsIDs)       ?? ["bitcoin"]
        let headerCoinExistInTheList   =  Defaults.load(key: .headerCoinExistInTheList)      ?? true
        
        addedCoins.removeAll()
        headerCoin = existedCoins.first(where: { $0.coinId == headerCoinId })
        for coinId in coinIds {
            if coinId == headerCoin?.coinId && !headerCoinExistInTheList {
                continue
            } else {
                if let coin = existedCoins.first(where: { $0.coinId == coinId }) {
                    addedCoins.append(coin)
                }
            }
        }
    }
    
    private func checkSubscription() {
        if !subscribed {
            addedCoins = addedCoins.customPrefix(n: freeCoinsCount)
            addedFiats = addedFiats.customPrefix(n: freeFiatsCount)
        }
        saveSubscribed = subscribed
    }
    
    public func updateSubscription() {
        let coinIds = Defaults.loadDefaults(key: .existedCoinsIDs) ?? ["bitcoin"]
        getExistedCoins(with: coinIds)
    }
    
    //MARK: - DispatchGroup -
    public func downloadCriptoData() {
        delegate?.startLoading()
        let dispatchGroup = DispatchGroup()
        // Get many coin
        dispatchGroup.enter()
        var existedCoinsIDs = ["bitcoin"]
        if let coinsIDs: [String] = Defaults.loadDefaults(key: .existedCoinsIDs) {
            existedCoinsIDs += coinsIDs
        }
        NetworkManager.shared.getExistedCoins(coinsIDs: existedCoinsIDs) { (existedCoins) in
            self.existedCoins = existedCoins
            dispatchGroup.leave()
        } failer: { (error) in
            self.error = error
            dispatchGroup.leave()
            debugPrint("Coins List downloading error---\(error)")
        }
        
        //Get Fiats
        dispatchGroup.enter()
        NetworkManager.shared.getAllFiats(success: { (fiats) in
            self.allFiats = fiats
            debugPrint("Fiat downloading successfully")
            dispatchGroup.leave()
        }) { (error) in
            self.error = error
            dispatchGroup.leave()
            debugPrint("Fiat downloading error---\(error)")
        }
        
        dispatchGroup.notify(queue: .main) {
            if !self.allFiats.isEmpty && !self.existedCoins.isEmpty {
                self.error = nil
                self.saveData()
                self.getState()
                self.convertAfterAddingCripto()
            } else {
                self.criptoDownloadedFailed()
            }
            self.delegate?.endLoading()
        }
    }
    
    private func saveData() {
        guard offlineMode else { return }
        RealmWrapper.shared.addObjectsInRealmDB(allFiats)
        RealmWrapper.shared.addObjectsInRealmDB(existedCoins)
    }
    
    private func criptoDownloadedFailed() {
        getLocalData (failer: {
            guard let errorMessage = error else { return }
            self.delegate?.requestFailed(with: errorMessage)
            error = nil
        })
    }
    
    private func getLocalData(failer: () -> Void) {
        if offlineMode,
           let fiats = DatabaseManager.shared.fiats,
           let existedCoins = DatabaseManager.shared.existedCoins {
            self.allFiats = fiats
            self.existedCoins = existedCoins
            getState()
        } else {
            failer()
        }
    }
    
}

//MARK: - Table Helpers
extension ConverterViewModel {
    public func  getNumberOfRowsInSection(_ section: Int) -> Int {
        if section == 0 {
           return !reversed ? ((infoCoinData != nil) ?  infoCoinData!.count + 1 : 1) : 1
        } else if section == 1 {
           return addedFiats.count + 1
        } else {
           return addedCoins.count + 1
        }
    }
    
    // helpers funsctions for deleting action
    public func controlCriptoExisting(for indexPath: IndexPath) -> Bool {
       if indexPath.section == 1 {
          if addedFiats.count == 1 {
             return false
          }
       } else if indexPath.section == 2 {
          if addedCoins.count == 1 {
             return false
          }
       }
       return true
    }
    
    public func deleteCripto(indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            addedFiats.remove(at: indexPath.row)
        case 2:
            addedCoins.remove(at: indexPath.row)
        default:
            break
        }
        saveState()
    }
    
    public func limitationCheck(_ section: Int) -> Bool {
        if section == 1 {
            return addedFiats.count < freeFiatsCount
        } else if section == 2 {
            return addedCoins.count < freeCoinsCount
        }
       return false
    }
    
}

// MARK: -- Reverse action delegate method implementation
extension ConverterViewModel: CoinFiatHeaderViewDelegate {
    func reverse() {
        reversed = !reversed
        convertAfterAddingCripto()
        Defaults.save(data: reversed, key: .converterReversed)
    }
}

//MARK: - SelectCoinFiatViewControllerDelegate
extension ConverterViewModel: SelectCoinFiatViewControllerDelegate {
    func getHeaderFiat(_ fiat: FiatModel) {
        headerFiat = fiat
        saveState()
        convertAfterAddingCripto()
    }
    
    func getFiat(_ fiat: FiatModel) {
        addedFiats.append(fiat)
        saveState()
        convertAfterAddingCripto()
    }
    
    func getHeaderCoin(_ coin: CoinModel) {
        headerCoin = coin
        saveState()
        convertAfterAddingCripto()
    }
    
    func getCoin(_ coin: CoinModel) {
        addedCoins.append(coin)
        saveState()
        convertAfterAddingCripto()
    }
}
