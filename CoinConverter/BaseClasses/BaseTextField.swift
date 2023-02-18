//
//  BaseTextField.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/18/19.
//

import UIKit

class BaseTextField: UITextField {
    
    private lazy var gradient: GradientLayer = {
        let gradient = GradientLayer(frame: self.bounds)
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    func initialSetup() {
        clipsToBounds = true
        layer.cornerRadius = Constants.radius
        textColor = darkMode ? .white : .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        gradient.setToFrame(frame: bounds)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
}
