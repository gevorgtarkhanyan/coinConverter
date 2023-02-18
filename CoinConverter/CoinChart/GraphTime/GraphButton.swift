//
//  GraphButton.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/19/19.
//

import UIKit

class GraphButton: BaseButton {
    
    override func initialSetup() {
        super.initialSetup()
        clipsToBounds = false
    }
    
    override func changeColors() {
        if isSelected {
            if let imageView = imageView {
                imageView.tintColor = .startGradient
            }
            setTitleColor(.startGradient, for: .normal)
        } else {
            if let imageView = imageView {
                imageView.tintColor = darkMode ? .white : .black
            }
            setTitleColor(darkMode ? .white : .black, for: .normal)
        }
    }
    
    public func setSelected(_ selected: Bool) {
        isSelected = selected
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }
    
}
