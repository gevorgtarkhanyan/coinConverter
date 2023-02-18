//
//  String_Extension.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 07.07.21.
//

import Foundation
import UIKit
import Localize_Swift

extension String {
    mutating func add(prefix: String) {
        self = prefix + self
    }
    
    func toDouble() -> Double? {
        let str = self.components(separatedBy: " ")
        let testStr = 777777.getFormatedString()
        let frFRStyle = testStr.contains(" ")
        
        for component in str {
            let subStr = component.components(separatedBy: frFRStyle ? "," : ".")
            var numToString = ""
            for (index, subComponent) in subStr.enumerated() {
                let newSubComponent = subComponent.filter { !" \n\t\r".contains($0) }
                numToString += newSubComponent
                if index == 0 && subStr.count > 1 {
                    numToString += "."
                }
            }
            if !frFRStyle {
                numToString.removeAll { $0 == ","}
            } else {
                numToString.removeAll { $0 == " "}
            }
            if let num = Double(numToString) {
                return num
            }
        }
        return nil
    }
    
    func getImageWithURL() -> UIImage {
        do {
            let data = try Data(contentsOf: URL(string: self)!)
            let imag: UIImage = UIImage(data: data) ?? UIImage()
            return imag
        } catch {
            print("URL is Valid")
            return UIImage()
        }
    }
    // MARK: -- Html support code
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func htmlAttributed(using font: UIFont) -> NSAttributedString? {
         do {
             let htmlCSSString = "<style>" +
                 "html *" +
                 "{" +
                 "font-size: \(font.pointSize)pt !important;" +
                 "font-family: \(font.familyName), Helvetica !important;" +
                 "}</style> \(self)"

             guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                 return nil
             }

             return try NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: nil)
         } catch {
             print("error: ", error)
             return nil
         }
     }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func convertForLocalize() -> String {
        let per = " (%)"
        switch self {
        case "rewards":             return "account_rewards"
        case "orphan":              return "orphaned"
        case "timestamp":           return "time"
        case "txHash":              return "tx"
        case "blockNumber":         return "blocks"
        case "cfms":                return "confirmations"
        case "shareDifficulty":     return "difficulty"
                
        case "luckPer":             return "luck".localized() + per
        case "txFeePer":            return "txFee".localized() + per
        case "networkFeePer":       return "networkFee".localized() + per
        case "sharePer":            return "shares".localized() + per
        default:                    return self
        }
    }

    mutating func removeOptional() {
        if contains("Optional") {
            removeFirst(8)
            self = filter { !"(\"\")".contains($0) }
        }
        if self == "nil" || self == "-1.0" {
            self = ""
        }
    }
}

