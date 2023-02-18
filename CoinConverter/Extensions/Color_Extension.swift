//
//  For_UIColor.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

extension UIColor {
    private class var darkMode: Bool {
        return UIView().darkMode
    }
    
    class var startGradient: UIColor {
        return getColor(red: 123, green: 189, blue: 255)
    }
    
    class var endGradient: UIColor {
        return getColor(red: 166, green: 223, blue: 255)
    }
    
    class var separator: UIColor {
        return getColor(red: 125, green: 125, blue: 125, alpha: 0.4)
    }
    
    class var layerColor: UIColor {
        return #colorLiteral(red: 0.4941176471, green: 0.7411764706, blue: 1, alpha: 1)
    }
    
    class var subscriptionEnd: UIColor {
        return #colorLiteral(red: 0.5411764706, green: 0.7254901961, blue: 0.8901960784, alpha: 1)
    }

    class var subscriptionStart: UIColor {
        return #colorLiteral(red: 0.1490196078, green: 0.1764705882, blue: 0.2235294118, alpha: 1)
    }
    
    class var backgroundDark: UIColor {
        return getColor(red: 38, green: 45, blue: 57)
    }
    
    class var backgroundLight: UIColor {
        return getColor(red: 244, green: 244, blue: 244)
    }
    
    class var appGray: UIColor {
        return #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    }
    
    class var popUpBackground: UIColor {
        return darkMode ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6993222268) :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
    }
    
    class var viewDarkBackgroundWithAlpha: UIColor {
        return getColor(red: 38, green: 45, blue: 57).withAlphaComponent(0.8)
    }

    class var viewLightBackgroundWithAlpha: UIColor {
        return getColor(red: 244, green: 244, blue: 244).withAlphaComponent(0.9)
    }
    
    class var barDark: UIColor {
        return getColor(red: 28, green: 28, blue: 28)
    }
    class var placeholder: UIColor {
        return getColor(red: 125, green: 125, blue: 125)
    }
    class var barLight: UIColor {
        return getColor(red: 249, green: 249, blue: 249, alpha: 0.94)
    }
    
    class var tableCellBackgroundLight: UIColor {
        return getColor(red: 255, green: 255, blue: 255)
    }
    
    class var tableCellBackgroundDark: UIColor {
        return getColor(red: 30, green: 32, blue: 34)
    }
    
    class var cellTrailingFirst: UIColor {
        return getColor(red: 30, green: 152, blue: 155)
    }
    
    class var textBlack: UIColor {
        return getColor(red: 0, green: 0, blue: 0).withAlphaComponent(0.85)
    }
    
    class var textFieldBackgorund: UIColor {
        return getColor(red: 118, green: 118, blue: 128).withAlphaComponent(0.24)
    }
    
    class var workerRed: UIColor {
        return getColor(red: 224, green: 32, blue: 32)
    }
    class var designBlack: UIColor {
        return getColor(red: 26, green: 31, blue: 39)
    }

    class var workerGreen: UIColor {
        return getColor(red: 92, green: 189, blue: 56)
    }
    
    class var graphLineGradientColors: [[UIColor]] {
        let firstLeft = getColor(red: 61, green: 138, blue: 239)
        let firstRight = getColor(red: 161, green: 225, blue: 191)

        let secondLeft = getColor(red: 143, green: 189, blue: 41)
        let secondRight = getColor(red: 224, green: 234, blue: 201)

        let thirdLeft = getColor(red: 21, green: 196, blue: 196)
        let thirdRight = getColor(red: 196, green: 240, blue: 240)

        let fourthLeft = getColor(red: 189, green: 98, blue: 196)
        let fourthRight = getColor(red: 251, green: 200, blue: 255)

        let fifthLeft = getColor(red: 255, green: 204, blue: 0)
        let fifthRight = getColor(red: 255, green: 243, blue: 196)

        return [[firstLeft, firstRight], [secondLeft, secondRight], [thirdLeft, thirdRight], [fourthLeft, fourthRight], [fifthLeft, fifthRight]]
    }
    
    private class func getColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}
