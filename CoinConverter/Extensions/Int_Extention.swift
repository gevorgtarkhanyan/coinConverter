//
//  Int_Extention.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 08.07.21.
//

import Foundation

extension Int {
    func getFormatedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 20
        
        if let str = numberFormatter.string(from: NSNumber(value: self)) {
            return str
        }
        
        return String(self)
    }
}
