//
//  FiatWidget.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 30.07.21.
//


import WidgetKit
import SwiftUI
import Intents

struct FiatProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> FiatWidgetEntry {
        FiatWidgetEntry(date: Date(), icon: " ", fiatIcon: " ", fiat2Icon: " ", fiat3Icon: " ", fiatPrice: 0, fiat2Price: 0, fiat3Price: 0, name: "", darkMode: true, configuration: FiatConfigurationIntent())
    }

    func getSnapshot(
        for configuration: FiatConfigurationIntent,
        in context: Context,
        completion: @escaping (FiatWidgetEntry) -> ()) {
        
        self.getFiatsList(configuration: configuration) { entry in
            completion(entry)
        }
    }

    func getTimeline(
        for configuration: FiatConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<FiatWidgetEntry>) -> ()) {
        var entries: [FiatWidgetEntry] = []
        
        
        self.getFiatsList(configuration: configuration) { entry in
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
    
    func getWidgetCoin(configuration: FiatConfigurationIntent, completion: @escaping (CoinModel) -> Void) {
        
        NetworkManager.shared.getExistedCoins(coinsIDs: [configuration.Coin?.identifier ?? "bitcoin"]) { existedCoins in
            
            guard let coin = existedCoins.first else { return }

            completion(coin)
            
        } failer: { error in
            debugPrint(error)
        }
    }
    
    func getFiatsList(configuration: FiatConfigurationIntent, completion: @escaping (FiatWidgetEntry) -> Void) {
        
        NetworkManager.shared.getAllFiats { fiats in
            var widgetFiatCurrensies:[String] = []
            var widgetFiats:[FiatModel] = []
            var fiat2IsShow = false
            var fiat3IsShow = false

            
            if let fiat = configuration.Fiat {
                widgetFiatCurrensies.append(fiat.displayString)
            }
            if let fiat2 = configuration.Fiat2, fiat2.displayString != "Unchecked" {
                widgetFiatCurrensies.append(fiat2.displayString)
                fiat2IsShow = true
            }
            if let fiat3 = configuration.Fiat3, fiat3.displayString != "Unchecked" {
                widgetFiatCurrensies.append(fiat3.displayString)
                fiat3IsShow = true
            }
            if widgetFiatCurrensies.isEmpty {
                widgetFiatCurrensies.append("USD")
            }
            
            for widgetfiatCurrensy in widgetFiatCurrensies {
                
                if let fiat = fiats.first(where: { $0.currency == widgetfiatCurrensy }) {
                    widgetFiats.append(fiat)
                }
            }
            
            getWidgetCoin(configuration: configuration) { widgetCoin in
                widgetFiats = converCoinToFiats(fiats: widgetFiats, coin: widgetCoin)
                
                var fiatEntry = FiatWidgetEntry(date: Date(), icon: widgetCoin.iconPath, fiatIcon:  widgetFiats.first!.iconPath, fiatPrice: widgetFiats.first!.changeAblePrice, name: widgetCoin.name,  configuration: configuration)
                if fiat2IsShow {
                    fiatEntry.fiat2Icon = widgetFiats[1].iconPath
                    fiatEntry.fiat2Price = widgetFiats[1].changeAblePrice
                }
                if fiat3IsShow {
                    fiatEntry.fiat3Icon = fiat2IsShow ? widgetFiats[2].iconPath :  widgetFiats[1].iconPath
                    fiatEntry.fiat3Price = fiat2IsShow ? widgetFiats[2].changeAblePrice :  widgetFiats[1].changeAblePrice
                }
                
                if let darkMode:Bool = Defaults.load(key: .darkMode) {
                    fiatEntry.darkMode = darkMode
                } else {
                    fiatEntry.darkMode = true
                }
                completion(fiatEntry)
            }
            
           
            
        } failer: { error in
            debugPrint(error)
        }

    }
    
    func converCoinToFiats(fiats:[FiatModel], coin: CoinModel) -> [FiatModel] {
        
            for fiat in fiats {
                let fiatPriceUSD = fiat.price
        
                let fiatPriceValue = coin.marketPriceUSD * fiatPriceUSD * 1
                fiat.changeAblePrice = fiatPriceValue
            }
        return fiats
    }
}

struct Fiat_Widget: Widget {
    let kind: String = "FiatWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: FiatConfigurationIntent.self,
            provider: FiatProvider()) { entry in
            FiatView(entry: entry)
        }
        .configurationDisplayName("Fiat")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

