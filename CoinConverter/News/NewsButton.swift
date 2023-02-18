//
//  NewsButton.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 21.01.22.
//

import Foundation
import UIKit
import Localize_Swift

class NewsButton: BaseButton {
    
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
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }

     override func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }

    override func changeColors() {
        darkMode ? setTitleColor(#colorLiteral(red: 0.4039215686, green: 0.4705882353, blue: 0.6039215686, alpha: 1) , for: .normal) : setTitleColor(.black, for: .normal)
        tintColor = darkMode ? .white : #colorLiteral(red: 0.4039215686, green: 0.4705882353, blue: 0.6039215686, alpha: 1)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

