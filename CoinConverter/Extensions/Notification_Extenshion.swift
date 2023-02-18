//
//  Notification_Extenshion.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 11.01.22.
//


import Foundation

extension Notification.Name {
    static var hideAdsForSubscribeUsers: Notification.Name {
        return Notification.Name(rawValue: "hide_ads")
    }
    static var likeStatusChanged: Notification.Name {
        return Notification.Name(rawValue: "like_status_changed")
    }
}
