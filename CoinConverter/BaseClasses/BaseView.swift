//
//  BaseView.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    
    private func initialSetup() {
        addObservers()
        changeColors()
        
        
        layer.cornerRadius = Constants.radius
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
        
    }

    @objc private func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
        
    }

    @objc public func changeColors() {
        
        backgroundColor = darkMode ? .designBlack : .white
        
        
        
    }
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
