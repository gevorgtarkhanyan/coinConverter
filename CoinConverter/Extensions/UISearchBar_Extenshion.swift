//
//  UISearchBar_Extenshion.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 27.12.21.
//

import Foundation
import UIKit

extension UISearchBar {
    public func setCancelButtonEnabled(_ enabled: Bool) {
        resignFirstResponder()
        if let cancelButton = value(forKey: "cancelButton") as? UIButton {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                cancelButton.isEnabled = enabled
            }
        }
    }
    
    public var cancelButton: UIButton? {
        for subView1 in subviews {
            for subView2 in subView1.subviews {
                if let cancelButton = subView2 as? UIButton {
                    return cancelButton
                }
            }
        }
        return nil
    }
}
