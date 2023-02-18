//
//  CACornerMask_Extension.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/4/19.
//

import UIKit

extension CACornerMask {
    static var topLeft: CACornerMask {
        return CACornerMask.layerMinXMinYCorner
    }

    static var topRight: CACornerMask {
        return CACornerMask.layerMaxXMinYCorner
    }

    static var bottomLeft: CACornerMask {
        return CACornerMask.layerMinXMaxYCorner
    }

    static var bottomRight: CACornerMask {
        return CACornerMask.layerMaxXMaxYCorner
    }
}
