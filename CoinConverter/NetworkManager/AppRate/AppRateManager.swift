//
//  AppRateManager.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 30.07.21.
//

import Foundation
import UIKit
import StoreKit

class AppRateManager {
    
    static let shared = AppRateManager()
    
    public func setupRateApp() {
        if (UserDefaults.standard.value(forKey: Constants.lastTimeInterval) as? TimeInterval) != nil {
            if let days = getDaysAppUsed() {
                if days >= Constants.showRateAppLastDays {
                    requestReviewIfAppropriate()
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: Constants.lastTimeInterval)
                }
            }
        } else {
            if let appOpenedCount = UserDefaults.standard.value(forKey: Constants.appOpenedCount) as? Int {
                if appOpenedCount == Constants.showRateAppOpenedTime {
                    requestReviewIfAppropriate()
                    if (UserDefaults.standard.value(forKey: Constants.lastTimeInterval) as? TimeInterval) == nil {
                        let date = Date()
                        let interval = date.timeIntervalSince1970
                        UserDefaults.standard.set(interval, forKey: Constants.lastTimeInterval)
                    }
                }
            }
        }
    }
    
    private func getDaysAppUsed() -> Int? {
        guard let savedTimeInterval = UserDefaults.standard.value(forKey: Constants.lastTimeInterval) as? TimeInterval else { return nil }
        
        let currentDate = Date()
        let intervalDate = currentDate.timeIntervalSince1970 - savedTimeInterval
        let usingAppTime = Date(timeIntervalSince1970: intervalDate)
        let calendar = Calendar.current
        let days = calendar.component(.day, from: usingAppTime)
        
        return days
    }
    
    public func requestReviewIfAppropriate() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            showRateAlert()
        }
    }
    
    public func showRateAlert() {
        let title = " \n \n "
        let message = "Enjoying MinerBox? \nRate us on the App Store."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let rateApp = UIAlertAction(title: "RateApp", style: .default, handler: rateAppButtonTapped(action:))
        alertController.addAction(cancel)
        alertController.addAction(rateApp)
        
        let imageView = UIImageView(frame: CGRect(x: 105, y: 15, width: 60, height: 60))
        imageView.image = UIImage(named: "icon_app")
        alertController.view.addSubview(imageView)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    private func rateAppButtonTapped(action: UIAlertAction) {
        guard let url = URL(string: "https://apps.apple.com/us/app/coin-converter-crypto-xe-calc/id1494639072") else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
