//
//  BaseNavigationController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return darkMode ? .lightContent : .darkContent
        } else {
            return darkMode ? .lightContent : .default
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        changeColors()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }
    
    private func setupNavigationBar() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor =  darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [.font:
            UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: darkMode    ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1)]
            // Customizing our navigation bar
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    @objc private func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }
 
    
    private func changeColors() {
        setupNavigationBar()
        navigationBar.barStyle = darkMode ? .black : .default
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = darkMode  ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBar.barTintColor = darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBar.tintColor = darkMode    ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1)
        navigationBar.titleTextAttributes  = [.foregroundColor: darkMode ? UIColor.white : UIColor.black ]
        navigationBar.addShadow()
        navigationBar.layoutIfNeeded()
    }
    
}
    
// MARK: - Actions
extension BaseNavigationController {
    fileprivate func changeColors1() {
        navigationBar.barStyle = darkMode ? .black : .default
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = darkMode ? .barDark : .barLight
        navigationBar.backgroundColor = .clear
        navigationBar.tintColor = .red
        navigationBar.layoutIfNeeded()
        view.backgroundColor = darkMode ? .barDark : .barLight

        if #available(iOS 11.0, *) {
            navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        }
    }
}
    

