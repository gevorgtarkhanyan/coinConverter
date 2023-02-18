//
//  FiatWidgetEntry.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 30.07.21.
//

import WidgetKit
import SwiftUI
import Intents


struct FiatWidgetEntry: TimelineEntry {
    var date: Date
    var icon: String
    var fiatIcon:String
    var fiat2Icon:String?
    var fiat3Icon:String?
    var fiatPrice:Double
    var fiat2Price:Double?
    var fiat3Price:Double?
    var name: String
    var darkMode:Bool?
    var configuration: FiatConfigurationIntent
}
