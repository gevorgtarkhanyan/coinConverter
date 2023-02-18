//
//  Constants.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

final class Constants {
    // MARK: - Base URL
    #if DEBUG
        static let HttpUrl              = "http://173.255.240.136:4000/api/"
        static let HttpUrlWithoutApi    = "http://173.255.240.136:4000/"

        static let HttpsUrl             = "https://173.255.240.136:4001/api/"
        static let HttpsUrlWithoutApi   = "https://173.255.240.136:4001/"
    #else
        static let HttpUrl              = "http://45.79.84.245:4000/api/"
        static let HttpUrlWithoutApi    = "http://45.79.84.245:4000/"

        static let HttpsUrl             = "https://45.79.84.245:4001/api/"
        static let HttpsUrlWithoutApi   = "https://45.79.84.245:4001/"
    #endif
    
    static let HttpNewsUrl =  "http://192.155.83.57:3020/"
    
    // MARK: - Realm
    static let RealmSchemaVersion: UInt64 = 0

    static var RealmDBUrl: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "com.witplex.CoinConverter")
        var directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "com.witplex.CoinConverter")!
        directory.appendPathComponent("DB.realm")
        return directory
    }

    static let HttpsCoinzilla = "https://request-global.czilladx.com/serve/native-app.php?z="
    
    static let animationDuration    = 0.2
    static let radius               = CGFloat(10)
    static let separatorHeight      = CGFloat(0.5)
    static let requestTimeOut       = TimeInterval(15)
    
    // Rate App
    static let appOpenedCount = "appOpenedCount"
    static let lastTimeInterval = "last_date"
    static let rateShowViaOpening = "rate_show_via_opening"
    
    static let showRateAppOpenedTime = 15
    static let showRateAppLastDays = 90
    
    //MARK: -- Keychain, uuid
    static let appGroupName = "com.witplex.CoinsConverter"
    static let deviceID = "deviceUUID"
    
    static let productID = ".purchase"
    static let mainCoinID = "bitcoin"
    
    static let receiptURL = Bundle.main.appStoreReceiptURL
    static let shareSecret = "1f77a273294847969deae088751833f2"
    
    static let loadingHeight: CGFloat = 44
    static let seaarchtTextChanged = "seracht_text_changed"
    static let addedNewSources = "added_new_sources"
    
    static let regularFont  = UIFont(name: "SFProText-Regular",     size: 12)       ??   UIFont.systemFont(ofSize: 12)
    static let semiboldFont = UIFont(name: "SFProText-Semibold",    size: 12)       ??   UIFont.systemFont(ofSize: 12)
    
    
    // MARK: - FileManager
    static var fileManagerURL: URL {
        let fileManager = FileManager.default
        return fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.witplex.CoinsConverter")!
    }

    // MARK: - News
    static let newslimit = 20
    static let searchTimeInterval = 0.5

    
    // coin
    static let limit = 500
    
    static let applicationGroupIdentifier = "group.com.witplex.CoinsConverter"
}
