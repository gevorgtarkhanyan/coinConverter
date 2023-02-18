//
//  UITextField_Extension.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/13/19.
//

import UIKit

extension UITextField {
    func allowOnlyNumbers(string: String) -> Bool {
        if text?.count == 0 && (string == "0" || string == ".") {
            text = "0."
            return false
        }
        
//        if Int(string) == nil && string != "" {
//            if string == "." {
//                if text!.contains(".") {
//                    return false
//                } else {
//                    return true
//                }
//            } else {
//                return false
//            }
//        }
        
        if text == "0." {
            if string == "" {
                text = ""
            }
            if string == "." {
                return false
            }
        }
        return true
    }
}
