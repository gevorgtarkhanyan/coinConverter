//
//  coinWidgetModel.swift
//  Convertor WidgetExtension
//
//  Created by Vazgen Hovakimyan on 21.07.21.
//


import WidgetKit
import SwiftUI
import Intents


struct CoinWidgetEntry: TimelineEntry {
    var date: Date
    var icon: String
    var id: String
    var marketPriceUSD: Double
    var name: String
    var change1h: Double
    var change24h: Double
    var change7d: Double
    var darkMode:Bool?
    var configuration: ConfigurationIntent
}


