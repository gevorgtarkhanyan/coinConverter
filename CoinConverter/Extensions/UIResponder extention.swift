//
//  UIResponder extention.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.08.21.
//

import UIKit

extension UIResponder {
    class var name: String {
        return String(describing: self)
    }
}

