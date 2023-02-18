//
//  CoinInfoDataModel.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/4/19.
//

import UIKit

class CoinInfoDataModel {
    var name = ""
    var value = ""
    
    init(key: String, value: String) {
        name = key
        self.value = value
    }
}
