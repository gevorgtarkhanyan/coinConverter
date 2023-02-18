//
//  FiatModel.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/16/19.
//

import RealmSwift

class FiatModel: Object, Codable {
    @objc dynamic var currency = ""
    @objc dynamic var symbol = ""
    @objc dynamic var icon = ""
    @objc dynamic var price: Double = 0
    var changeAblePrice: Double = 0
    
    override class func primaryKey() -> String? {
        return "currency"
    }
    
    init(json: NSDictionary) {
        super.init()
        self.currency = json.value(forKey: "name") as? String ?? ""
        self.symbol = json.value(forKey: "symbol") as? String ?? ""
        self.icon = json.value(forKey: "icon") as? String ?? ""
        self.price = json.value(forKey: "usdRate") as? Double ?? 0
    }
    
    override init() {}
    
    static func == (lhs: FiatModel, rhs: FiatModel) -> Bool {
        return lhs.currency == rhs.currency
    }
    
    var iconPath: String {
        return Constants.HttpUrlWithoutApi + "/images/fiats/" + icon
    }
}
