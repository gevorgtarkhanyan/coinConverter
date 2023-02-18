//
//  GraphTimeData.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/19/19.
//

import Foundation

enum GraphTimeData: String, CaseIterable {
    case day = "24h"
    case week = "1w"
    case month = "1m"
    case treeMonth = "3m"
    case sixMonth = "6m"
    case year = "1y"
    case all = "all"
}
