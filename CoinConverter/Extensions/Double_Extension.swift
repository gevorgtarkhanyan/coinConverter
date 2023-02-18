//
//  Double_Extension.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/15/20.
//

import Foundation

extension Double {
    func getDateFromUnixTime() -> String {
        if self > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy HH:mm"
            return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self)))
        } else {
            return ""
        }
    }
    
    func getString() -> String {
        var doubleString = String(self)
        if self > 1 {
            let largeNumber = self
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let str = numberFormatter.string(from: NSNumber(value: largeNumber)) {
                doubleString = str
            }
        } else {
            doubleString = String(format: "%f", self)
            let newDouble = Double(doubleString)!

            if floor(newDouble) == newDouble {
                return String(Int64(newDouble))
            }

            while doubleString.last == "0" {
                doubleString.removeLast()
            }
        }

        return doubleString
    }
    
    func formatWithCurrency(locale: Locale? = nil) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .behavior10_4
        formatter.locale = locale ?? formatter.locale
        
        return formatter.string(from: NSNumber(value: self))
    }
    
    //calling on the monthlyCost
    func calculateSavings(with yearlyCost: Double) -> (formatedNewMonthlyCost: String, percent: Int) {
        var newMonthlyCost = yearlyCost / 12
        let savingsAmount = self - newMonthlyCost
        var percentAmount = (savingsAmount * 100) / self
        
        newMonthlyCost.roundUpToDecimal(2)
        percentAmount.round(.up)
        let formatedNewMonthlyCost = newMonthlyCost.formatWithCurrency(locale: Locale.subscriptionLocale) ?? String(newMonthlyCost)
        let intPercentAmount = !percentAmount.isNaN ? Int(percentAmount) : 0
        return (formatedNewMonthlyCost: formatedNewMonthlyCost, percent: intPercentAmount)
    }

    mutating func roundUpToDecimal(_ fractionDigits: Int) {
        let multiplier = pow(10, Double(fractionDigits))
        let fractionAdd = 1 / multiplier
        
        let newSelf = Darwin.round(self * multiplier) / multiplier
        self = newSelf >= self ? newSelf : newSelf + fractionAdd
    }
    
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    func getStringmaximumFractionDigits3() -> String {
        guard !self.isNaN else { return "0" }
        
        var doubleString = String(self)
        var largeNumber = self
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if self < 1 && self != 0 && self > -1 {
            doubleString = String(format: "%f", self)
            numberFormatter.maximumFractionDigits = 3
            //for the small number 2.1e-14
            if numberFormatter.string(from: NSNumber(value: largeNumber)) == "0" {
                largeNumber = largeNumber > 0 ? 0.000001 : -0.000001
            } else {
                largeNumber = Double(doubleString) ?? self
            }
        }
        
        if let str = numberFormatter.string(from: NSNumber(value: largeNumber)) {
            doubleString = str
        }
        return doubleString
    }
    
    func getDateRangeInCurrentDate() -> String {
        guard self > 0 else { return "" }

        let date =  Date(timeIntervalSince1970: TimeInterval(self))
        
        return  Date().offset(from: date)

    }
}
