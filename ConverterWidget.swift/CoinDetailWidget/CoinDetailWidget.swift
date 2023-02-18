//
//  ConverterWidget.swift
//  ConverterWidget
//
//  Created by Vazgen Hovakimyan on 26.07.21.
//

import WidgetKit
import SwiftUI
import Intents

struct CoinDetailProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> CoinWidgetEntry {
        CoinWidgetEntry(date: Date(), icon: "", id: "", marketPriceUSD: 0, name: "", change1h: 0, change24h: 0, change7d: 0, darkMode: true, configuration: ConfigurationIntent())
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (CoinWidgetEntry) -> ()) {
        
        self.getWidgetCoin(configuration: configuration) { entry in
            completion(entry)
        }
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<CoinWidgetEntry>) -> ()) {
        var entries: [CoinWidgetEntry] = []
        
        
        self.getWidgetCoin(configuration: configuration) { entry in
            entries.removeAll()
            entries.append(entry)
            
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
            var entry2 = entry
            entry2.date = nextUpdateDate
            entries.append(entry2)

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        
    }
    
    func getWidgetCoin(configuration: ConfigurationIntent, completion: @escaping (CoinWidgetEntry) -> Void) {
        
        NetworkManager.shared.getExistedCoins(coinsIDs: [configuration.Coin?.identifier ?? "bitcoin"]) { existedCoins in
            
            guard let coin = existedCoins.first else { return }

            var entry = CoinWidgetEntry(date: Date(), icon: coin.iconPath, id: coin.id, marketPriceUSD: coin.marketPriceUSD, name: coin.name, change1h: coin.change1h, change24h: coin.change24h, change7d: coin.change7d, configuration: configuration)
            if let darkMode:Bool = Defaults.load(key: .darkMode) {
                entry.darkMode = darkMode
            } else {
                entry.darkMode = true
            }
            
            completion(entry)
            
        } failer: { error in
            debugPrint(error)
        }
    }
}

struct Convertor_Widget: Widget {
    let kind: String = "CoinDetailWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: CoinDetailProvider()) { entry in
            CoinDetailView(entry: entry)
        }
        .configurationDisplayName("Coin Detail")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

