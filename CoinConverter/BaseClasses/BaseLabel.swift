//
//  BaseLabel.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

class BaseLabel: UILabel {
    
    private var baseFont = Font.regularFont

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        addObservers()
        changeColors()
        changeFontSize(to: font.pointSize)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }
    
    @objc public func themeChanged() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.changeColors()
            }
        }
    }
    
    @objc public func changeColors() {
        textColor = darkMode ? .white : UIColor.black.withAlphaComponent(0.85)
    }
    
    public func changeFontSize(to value: CGFloat) {
        font = baseFont.withSize(value)
        adjustsFontSizeToFitWidth = true
    }
    
    public func changeFont(to font: UIFont) {
        baseFont = font
        changeFontSize(to: self.font.pointSize)
    }
    
    public func setLocalizableText(_ localizableString: String) {
        self.text = localizableString
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
