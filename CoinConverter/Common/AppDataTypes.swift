//
//  AppDataTypes.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/20/20.
//

import Foundation
import UIKit

enum CriptoType: String {
    case coin = "Coin"
    case fiat = "Fiat"
}

struct ConverterAPI {
    static let allCoinsAPI = "coin/list"
    static let chartAPI = "coin/getHistory/coin_id/time_period"
    static var fiatAPI = "fiats"
    static var subscriptionAddAPI = "subscription/u_id/add"
    static var subscriptionGetAPI = "subscription/u_id/get"
    static var coinAPI = "coin/coin_id"
    static var existedCoins = "coin/manyCoin"
}

struct ConverterLink {//https://apps.apple.com/us/app/coinconverter-crypto-currency/id1494639072
    static let iosLink        = "https://apps.apple.com/us/app/coinconverter-crypto-currency/id1494639072"//"itms-apps://itunes.apple.com/app/coinconverter/id1494639072?ls=1&mt=8"
    static let androidLink    = "https://play.google.com/store/apps/details?id=com.witplex.coinconverter"
    static let webLink        = "http://www.witplex.com"
    static let privacyPolicy  = "http://www.witplex.com/CoinConverter/PrivacyPolicy/"
    static let termsOfUse     = "http://www.witplex.com/CoinConverter/TermOfUse/"
}

struct ConverterNotification {
    static let themeChanged = "theme_changed_notification"
}

enum DefaultCases: String {
    
    //Converter
    case coins = "coins_list"
    case fiats = "fiats_list"
    case existedCoins = "existedCoins"
    case existedCoinsForWidgetSetting = "existedCoinsForWidgetSetting"
    case headerFiat = "header_fiat"
    case headerCoin = "header_coin"
    case addedCoins = "added_coins"
    case addedFiats = "added_fiats"
    case mainCoin = "main_coin"
    case multiplier = "multiplier"
    
    case converterHeaderCoinId = "converterHeaderCoinId"
    case converterHeaderFiatCurrency = "converterHeaderFiatCurrency"
//    case converterCoinsIds = "converterCoinsIds"
    case existedCoinsIDs = "existed_Coins_IDs"
    case existedFiatCurrencys = "existedFiatCurrencys"
    case headerCoinExistInTheList = "headerCoinExistInTheList"
    case headerFiatExistInTheList = "headerFiatExistInTheList"
    case converterReversed = "converterReversed"
    
    case freeCoinsCount = "free_coins_count"
    
    //Settings
    case coinSettingsVertical = "coin_graph_settings_vertical"
    case coinSettingsHorizontal = "coin_graph_settings_horizontal"
    case coinSettingsLineGraph = "coin_graph_settings_line_graph"
    
    case darkMode     = "dark_mode"
    case offlineMode  = "offline_mode"
    case removeAds  = "remove_ads"
    case subscribed   = "subscribed_user"
    case isPromo      = "isPromo"
    case subscriptionSendFiled = "subscriptet_send_to_server_failed"

    //Subscription
    case productPriceMonthly = "product_price_monthly"
    case productPriceYearly = "product_price_yearly"
    case skProduct = "sk_product"
    case subscriptionType = "subscriptionType"
    case subscriptionData = "subscriptionData"
    case sandBoxSubscriptionData = "sandBoxSubscriptionData"
    case formatedNewMonthlyCost
    case subscriptrionLocale
    
    case inputValue = "input_value"
}

// MARK: - Font
struct Font {
    static let boldFont          = UIFont(name: "SFProText-Bold",        size: 14) ?? UIFont.systemFont(ofSize: 14)
    static let regularFont       = UIFont(name: "SFProText-Regular",     size: 14) ?? UIFont.systemFont(ofSize: 14)
    static let robotoRegularFont = UIFont(name: "Roboto-Regular",        size: 14) ?? UIFont.systemFont(ofSize: 14)
    static let semiboldFont      = UIFont(name: "SFProText-Semibold",    size: 14) ?? UIFont.systemFont(ofSize: 14)
    static let mediumFont        = UIFont(name: "SFProText-Medium",      size: 14) ?? UIFont.systemFont(ofSize: 14)
}

struct Messages {
    static let cannotMakePayments = "\(notAuthorized) \(installing)"
    static let couldNotFind = "Could not find resource file:"
    static let deferred = "Allow the user to continue using your app."
    static let deliverContent = "Deliver content for"
    static let emptyString = ""
    static let error = "Error: "
    static let failed = "failed."
    static let installing = "In-App Purchases may be restricted on your device."
    static let invalidIndexPath = "Invalid selected index path"
    static let noRestorablePurchases = "There are no restorable purchases.\n\(previouslyBought)"
    static let noPurchasesAvailable = "No purchases available."
    static let notAuthorized = "You are not authorized to make payments."
    static let okButton = "OK"
    static let previouslyBought = "Only previously bought non-consumable products and auto-renewable subscriptions can be restored."
    static let productRequestStatus = "Product Request Status"
    static let purchaseOf = "Purchase of"
    static let purchaseStatus = "Purchase Status"
    static let removed = "was removed from the payment queue."
    static let restorable = "All restorable transactions have been processed by the payment queue."
    static let restoreContent = "Restore content for"
    static let status = "Status"
    static let unableToInstantiateAvailableProducts = "Unable to instantiate an AvailableProducts."
    static let unableToInstantiateInvalidProductIds = "Unable to instantiate an InvalidProductIdentifiers."
    static let unableToInstantiateMessages = "Unable to instantiate a MessagesViewController."
    static let unableToInstantiateNavigationController = "Unable to instantiate a navigation controller."
    static let unableToInstantiateProducts = "Unable to instantiate a Products."
    static let unableToInstantiatePurchases = "Unable to instantiate a Purchases."
    static let unableToInstantiateSettings = "Unable to instantiate a Settings."
    static let unknownDefault = "Unknown payment transaction case."
    static let unknownDestinationViewController = "Unknown destination view controller."
    static let unknownDetail = "Unknown detail row:"
    static let unknownPurchase = "No selected purchase."
    static let unknownSelectedSegmentIndex = "Unknown selected segment index: "
    static let unknownSelectedViewController = "Unknown selected view controller."
    static let unknownTabBarIndex = "Unknown tab bar index:"
    static let unknownToolbarItem = "Unknown selected toolbar item: "
    static let updateResource = "Update it with your product identifiers to retrieve product information."
    static let useStoreRestore = "Use Store > Restore to restore your previously bought non-consumable products and auto-renewable subscriptions."
    static let viewControllerDoesNotExist = "The main content view controller does not exist."
    static let windowDoesNotExist = "The window does not exist."
    static let internetLost = "The internet connection is lost"
    // end subscription
    
    static let uidNotFound = "Can't get device uid from keychain. Generating new."
    static let appStoreURLNotFound = "Can't get app store url"
    static let subscriptInfoEmpty = "Subscription info is empty"
    static let unknownAppVersion = "Unknown application version"
    static let unknownError = "Unknown error occured"
    static let feedbackEmailErrorMessage    = "Email is not configured!"
    
    static let sharingText  = "Hey, I am using this great app for price checking and converting Cryptocurrencies to Fiat and vice versa!\nDownload it free iOS: iosLink \n Android: androidLink ";
}

