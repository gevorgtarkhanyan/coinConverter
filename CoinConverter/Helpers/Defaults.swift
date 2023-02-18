//
//  Defaults.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/26/19.
//

import Foundation

struct Defaults {
    //must be removed
    static func saveDefaults<T:Codable>(data: T, key: DefaultCases) {
        guard let userDefaults = UserDefaults(suiteName: "group.com.witplex.CoinConverter.data") else { return }
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: key.rawValue)
    }
    //must be removed
    static func loadDefaults<T:Codable>(key: DefaultCases) -> T? {
        guard let userDefaults = UserDefaults(suiteName: "group.com.witplex.CoinConverter.data") else { return nil }
        if let data = userDefaults.value(forKey: key.rawValue) as? Data {
            let cardInfo = try? PropertyListDecoder().decode(T.self, from: data)
            return cardInfo
        }
        return nil
    }
    
    static func save(data: Any?, key: DefaultCases) {
        guard let userDefaults = UserDefaults(suiteName: "group.com.witplex.CoinConverter") else { return }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    static func load<T>(key: DefaultCases) -> T? {
        guard let userDefaults = UserDefaults(suiteName: "group.com.witplex.CoinConverter") else { return nil }
        return userDefaults.object(forKey: key.rawValue) as? T
    }
    
    static func bool(key: DefaultCases) -> Bool {
        return Defaults.load(key: key) ?? false
    }
    
    //must be removed
    static func removeAllData() {
        guard let userDefaults = UserDefaults(suiteName: "group.com.witplex.CoinConverter.data") else { return }
        userDefaults.removeObject(forKey: DefaultCases.fiats.rawValue)
        userDefaults.removeObject(forKey: DefaultCases.coins.rawValue)
        userDefaults.removeObject(forKey: DefaultCases.existedCoins.rawValue)
    }
    
    static func removeObject(forKey: DefaultCases) {
        UserDefaults(suiteName: "group.com.witplex.CoinConverter")?.removeObject(forKey: forKey.rawValue)
    }
    
}
