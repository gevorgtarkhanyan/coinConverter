//
//  UIBarButtonItem_Extenshion.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 27.12.21.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    static func customButton(_ target: Any?, action: Selector, imageName: String, tag: Int = -1) -> UIBarButtonItem {
        let heightConstant: CGFloat = 25
        let widthConstant: CGFloat = 30

        if #available(iOS 11, *) {
            let button = UIButton(type: .system)
            button.backgroundColor = .clear
            button.tintColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.addTarget(target, action: action, for: .touchUpInside)

            let customBarItem = UIBarButtonItem(customView: button)
            customBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
            customBarItem.customView?.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
            customBarItem.customView?.widthAnchor.constraint(equalToConstant: widthConstant ).isActive = true
            
            
            return customBarItem
        } else {
            let button = UIButton(type: .custom)
            button.tintColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
            button.backgroundColor = .clear
            button.frame = CGRect(x: 0.0, y: 0.0, width: widthConstant , height: heightConstant)
            let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.addTarget(target, action: action, for: .touchUpInside)

            return UIBarButtonItem(customView: button)
        }
    }
}
