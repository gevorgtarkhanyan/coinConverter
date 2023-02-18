//
//  CGRect_Extension.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/26/19.
//

import UIKit

extension CGRect {
    var center : CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
