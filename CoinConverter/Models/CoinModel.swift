//
//  CoinModel.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/16/19.
//

import RealmSwift

class CoinModel: Object, Codable {
    
    @objc dynamic var id = ""
    @objc dynamic var icon = ""
    @objc dynamic var coinId = ""
    @objc dynamic var symbol = ""
    @objc dynamic var name = ""
    @objc dynamic var isFavorite = false
    
    @objc dynamic var rank: Int = 0
    @objc dynamic var marketCapUsd: Double = 0
    @objc dynamic var marketPriceUSD: Double = 0
    @objc dynamic var marketPriceBTC: Double = 0
    @objc dynamic var lastUpdated: Double = 0
    @objc dynamic var change1h: Double = 0
    @objc dynamic var change24h: Double = 0
    @objc dynamic var change7d: Double = 0
    
    @objc dynamic var volumeUSD: Double = 0
    @objc dynamic var availableSupply: Int = 0
    @objc dynamic var totalSupply: Int = 0
    
    @objc dynamic var previousPriceUSD: Double = 0
    var changeAblePrice: Double = 0
    
    @objc dynamic var websiteUrl: String?
    @objc dynamic var redditUrl: String?
    @objc dynamic var twitterUrl: String?
    var expLinks = List<String>()
    
    var explorerLinks: [String] {
        return expLinks.map { $0 }
    }
    
    override class func primaryKey() -> String? {
        return "coinId"
    }
    
    init(marketPriceBTC: Double, marketPriceUSD: Double, marketCapUsd: Double, name: String, symbol: String, icon: String, lastUpdated: Double) {
        self.marketPriceBTC = marketPriceBTC
        self.marketPriceUSD = marketPriceUSD
        self.marketCapUsd = marketCapUsd
        self.name = name
        self.symbol = symbol
        self.icon = icon
        self.lastUpdated = lastUpdated
    }
    
    init(json: NSDictionary) {
        super.init()
        self.id = json.value(forKey: "_id") as? String ?? ""
        self.coinId = json.value(forKey: "coinId") as? String ?? ""
        self.change1h = json.value(forKey: "change1h") as? Double ?? 0
        self.change24h = json.value(forKey: "change24h") as? Double ?? 0
        self.change7d = json.value(forKey: "change7d") as? Double ?? 0
        self.lastUpdated = json.value(forKey: "lastUpdated") as? Double ?? 0
        self.marketPriceBTC = json.value(forKey: "marketPriceBTC") as? Double ?? 0
        self.marketPriceUSD = json.value(forKey: "marketPriceUSD") as? Double ?? 0
        self.marketCapUsd = json.value(forKey: "marketCapUsd") as? Double ?? 0
        self.name = json.value(forKey: "name") as? String ?? "-"
        self.previousPriceUSD = json.value(forKey: "previousPriceUSD") as? Double ?? 0
        self.rank = json.value(forKey: "rank") as? Int ?? 0
        self.symbol = json.value(forKey: "symbol") as? String ?? "-"
        
        if let icon = json.value(forKey: "icon") as? String, let path = icon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            self.icon = path
        }
        
        self.volumeUSD = json.value(forKey: "volumeUSD") as? Double ?? 0
        self.availableSupply = json.value(forKey: "availableSupply") as? Int ?? 0
        self.totalSupply = json.value(forKey: "totalSupply") as? Int ?? 0
        
        self.websiteUrl = json.value(forKey: "websiteUrl") as? String
        self.redditUrl = json.value(forKey: "redditUrl") as? String
        self.twitterUrl = json.value(forKey: "twitterUrl") as? String
        let explorerLinks = json.value(forKey: "explorerLinks") as? [String] ?? []
        self.expLinks.append(objectsIn: explorerLinks)
    }
    
    override init() {}
    
    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    var iconPath: String {
        return Constants.HttpUrlWithoutApi + "/images/coins/" + icon
    }
}

class CoinModelForWidgetSetting: NSObject, Codable {
    
    var coinId = ""
    var name = ""
    
     init(coinId: String, name: String) {
        self.coinId = coinId
        self.name = name
    }
    
}
