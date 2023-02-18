//
//  NewsLabel.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 21.01.22.
//

import Foundation
import UIKit

class NewsLabel: BaseLabel {
    
    override func changeColors() {
        textColor = darkMode ? .white : #colorLiteral(red: 0.4039215686, green: 0.4705882353, blue: 0.6039215686, alpha: 1)
    }
}
