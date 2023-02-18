//
//  TimerManager.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 04.01.22.
//

import Foundation
import UIKit


class TimerManager: NSObject {

    static let shared = TimerManager()
    
    private override init() {}
    
    private var oldDate = Date()
    
    public enum Item: String {
        case welcome
        case community
        case adsHide
        case fiats
        case adsList
        case coinWidget
        case accountWidget
        case myNews
        case topNews
        case allNews

        
        var defaultsKey: String {
            return "timerManager/" + rawValue
        }
        
        var duration: Int {
            switch self {
            case .welcome, .community:
                return 86400 // oneDayInSecond
            case .adsList:
                return 900 // 15minuteInSecond
            case .fiats:
                return 30 * 60
            case .coinWidget:
                return 60
            case .accountWidget:
                return 60
            case .myNews:
                return 60
            case .topNews:
                return 60
            case .allNews:
                return 60
            default:
                return 0
            }
        }
    }
    
    public func setDurationTime(item: Item) {
        UserDefaults.standard.set(Date(), forKey: item.defaultsKey)
    }
    
    public func isLoadingTime(item: Item, duration: Int? = nil) -> Bool {
        let newDuration = duration ?? item.duration
        return isRefreshRequired(key: item.defaultsKey, duration: newDuration)
    }
    
    public func failed(_ item: Item) {
        UserDefaults.standard.set(oldDate, forKey: item.defaultsKey)
    }

    private func isRefreshRequired(key: String, duration: Int) -> Bool {
        if let lastRefreshDate = UserDefaults.standard.object(forKey: key) as? Date {
            if let diff = Calendar.current.dateComponents([.second], from: lastRefreshDate, to: Date()).second, diff > duration {
                oldDate = lastRefreshDate
                UserDefaults.standard.set(Date(), forKey: key)
                return true
            } else {
                return false
            }
        } else {
            UserDefaults.standard.set(Date(), forKey: key)
            return true
        }
    }
}

