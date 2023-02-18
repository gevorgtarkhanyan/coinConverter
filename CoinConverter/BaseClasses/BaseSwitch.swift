//
//  BaseSwitch.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/12/19.
//

import UIKit

class BaseSwitch: UISwitch {
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
    }
    
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeColors), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }
    
    @objc func changeColors() {
        onTintColor = .startGradient
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
