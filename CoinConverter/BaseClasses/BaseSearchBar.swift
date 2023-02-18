//
//  BaseSearchBar.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/13/19.
//

import UIKit
import Localize_Swift


class BaseSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        awakeFromNib()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        changeColors()
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: NSNotification.Name(ConverterNotification.themeChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func themeChanged() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.changeColors()
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ sender: Notification) {
        setCancelButtonEnabled(true)
    }
    
    private func changeColors() {
        tintColor = .appGray
        barStyle = darkMode ? .black : .default
        barTintColor = darkMode ? .barDark : .barLight
        backgroundColor = .clear
        
        setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        
        if let searchTextField = value(forKey: "searchField") as? UITextField {
            searchTextField.addShadow()
            searchTextField.textColor = darkMode ? .white : .textBlack
            searchTextField.keyboardAppearance = darkMode ? .dark : .default
            searchTextField.backgroundColor = darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        languageChanged()
    }
    
    @objc fileprivate func languageChanged() {
        showsCancelButton = false
        self.setValue("cancel".localized(), forKey: "cancelButtonText")
        showsCancelButton = true

        guard let searchTextField = value(forKey: "searchField") as? UITextField else { return }

        searchTextField.textColor = darkMode ? .white : .textBlack
        searchTextField.keyboardAppearance = darkMode ? .dark : .default

        searchTextField.backgroundColor = darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchTextField.layer.shadowColor = UIColor.darkGray.cgColor
        searchTextField.attributedPlaceholder = NSAttributedString(string: "search".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholder ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
