//
//  BaseButton.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/16/19.
//

import UIKit
import Localize_Swift

class BaseButton: UIButton {
    
    // MARK: - Properties
    private var titleFont = Font.robotoRegularFont
    fileprivate(set) var localizableTitle = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup() {
        clipsToBounds  = true
        layer.cornerRadius = Constants.radius
        
        addObservers()
        changeColors()
        changeFontSize(to: 16)
        setTitle(titleLabel?.text?.localized(), for: .normal)
    }
    @objc public func languageChanged() {
        setTitle(localizableTitle.localized(), for: .normal)
    }
    
    public func setLocalizedTitle(_ title: String) {
        localizableTitle = title
        languageChanged()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }
    
    @objc public func changeColors() {
        darkMode ? setTitleColor(.white, for: .normal) : setTitleColor(.black, for: .normal)
        tintColor = darkMode ? .white : .black
    }
    
    public func setTitleKey(_ title: String, size: CGFloat = 16) {
        setTitle(title.localized(), for: .normal)
        changeFontSize(to: size)
    }
    
    public func changeFontSize(to size: CGFloat) {
        titleLabel?.font = titleFont.withSize(size)
    }
    
    public func changeFont(to font: UIFont) {
        titleFont = font
        changeFontSize(to: self.titleLabel?.font.pointSize ?? 12)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
