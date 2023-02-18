//
//  SettingsData.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/17/19.
//

import Foundation

enum SettingsData: String {
    case darkMode = "dark_mode"
    case offlineMode = "offline_mode"
    case adsRemove = "remove_ads"
    case feedback = "feedback"
    case share = "share_app"
    case rate = "rate_app"
    case subscription = "manage_subscription"
    case languages = "languages"
    case website = "company_website"
    case appVersion = "app_version"
    
    var localizedRawValue: String {
        return self.rawValue.localized()
    }
    
    static func firstSection() -> [SettingsData] {
        return [.subscription, .languages]
    }
    
    static func secondSection() -> [SettingsData] {
        return [.darkMode, .offlineMode,adsRemove]
    }
    
    static func thirdSection() -> [SettingsData] {
        return [.feedback, .share, .rate]
    }
    
    static func fourthSection() -> [SettingsData] {
        return [.website, .appVersion]
    }
    
    static func getSettingsData() -> [[SettingsData]] {
        return [firstSection(), secondSection(), thirdSection(), fourthSection()]
    }
}
