//
//  GradientButton.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/19/19.
//

import UIKit

class GradientButton: BaseButton {

    private lazy var gradient: GradientLayer = {
        let gradient = GradientLayer(frame: self.bounds)
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.setToFrame(frame: bounds)
    }
    
    public func subscribedSetup() {
        
    }
    
}
