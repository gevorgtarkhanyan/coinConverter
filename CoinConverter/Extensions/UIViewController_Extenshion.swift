//
//  UIViewController_Extenshion.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 28.12.21.
//

import Foundation
import UIKit

extension UIViewController {
    
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
    
    var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.size.height ?? 0.0
    }
    
    // MARK: - Toast Alert
    func showToastAlert(_ title: String?, message: String?) {
        DispatchQueue.main.async {
            self.showToastAlertInMain(title, message: message, finished: { })
        }
    }

    func showToastAlert(_ title: String?, message: String?, finished: @escaping() -> ()) {
        DispatchQueue.main.async {
            self.showToastAlertInMain(title, message: message, finished: finished)
        }
    }

    fileprivate func showToastAlertInMain(_ title: String?, message: String?, finished: @escaping() -> ()) {
        let alertController = getAlertController(title: title, message: message)
        self.present(alertController, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alertController.dismiss(animated: true, completion: nil)
            finished()
        }
    }
    
    // MARK: - Helper
    fileprivate func getAlertController(title: String?, message: String?) -> UIAlertController {
        let textColor = darkMode ? .white : UIColor.black.withAlphaComponent(0.85)

        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
            subview.backgroundColor = darkMode ? .backgroundDark : .backgroundLight
        }

        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: Constants.semiboldFont.withSize(17), .foregroundColor: textColor]
        let attributedTitle = NSAttributedString(string: title?.localized() ?? "", attributes: titleAttributes)

        // Message
        let messageAttributes: [NSAttributedString.Key: Any] = [.font: Constants.regularFont.withSize(17), .foregroundColor: textColor]
        let attributedMessage = NSAttributedString(string: message?.localized() ?? "", attributes: messageAttributes)

        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        
        return alertController
    }
}


