//
//  DatabaseManager.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 12.01.22.
//

import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var coins: [CoinModel]? {
        return RealmWrapper.shared.getAllObjectsOfModel(CoinModel.self)
    }
    
    var fiats: [FiatModel]? {
        return RealmWrapper.shared.getAllObjectsOfModel(FiatModel.self)
    }
    
    var existedCoins: [CoinModel]? {
        guard let coinIds: [String] = Defaults.loadDefaults(key: .existedCoinsIDs) else { return nil }
        return RealmWrapper.shared.objectsOfKeys(forPrimaryKeys: coinIds)
    }
    
    var existedFiats: [FiatModel]? {
        guard let currencys: [String] = Defaults.loadDefaults(key: .existedFiatCurrencys), !currencys.isEmpty else { return nil }
        return RealmWrapper.shared.objectsOfKeys(forPrimaryKeys: currencys)
    }
    
    
    //MARK: - Migration
    func migrateRealm() {
        let config = Realm.Configuration(
            schemaVersion: Constants.RealmSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in

            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
}

