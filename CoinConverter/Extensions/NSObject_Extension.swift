//
//  For_NSObject.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import WidgetKit

extension NSObject {
    public var darkMode: Bool {
        set {
            Defaults.save(data: newValue, key: .darkMode)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConverterNotification.themeChanged), object: nil)
            if #available(iOS 14.0, *) {
                #if arch(arm64) || arch(i386) || arch(x86_64)
                WidgetCenter.shared.reloadAllTimelines()
                #endif
            }
        }
        get {
            return Defaults.load(key: .darkMode) ?? true
        }
    }
    
    public var offlineMode: Bool {
        set {
            Defaults.save(data: newValue, key: .offlineMode)
        }
        get {
            return Defaults.bool(key: .offlineMode)
        }
    }
    
    public var removeAds: Bool {
        set {
            Defaults.save(data: newValue, key: .removeAds)
        }
        get {
            return Defaults.bool(key: .removeAds)
        }
    }
    
    public var subscribed: Bool {
        return Defaults.bool(key: .subscribed) || Defaults.bool(key: .isPromo)
    }
    
}
