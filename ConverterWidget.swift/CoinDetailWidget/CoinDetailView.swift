//
//  SingleCoinView.swift
//  Convertor WidgetExtension
//
//  Created by Vazgen Hovakimyan on 22.07.21.
//

import WidgetKit
import SwiftUI

struct CoinDetailView : View {
    var entry: CoinDetailProvider.Entry
    
    var body: some View {

        ZStack {
            if entry.darkMode! {
            Color(red: 38/255, green: 45/255, blue: 57/255)
            } else {
            Color(red: 244/255, green: 244/255, blue: 244/255)
            }
            VStack(alignment: .center,spacing: 10) {
                VStack(alignment: .center,spacing: 6)  {
                    if entry.icon != "" {
                        Image(uiImage: entry.icon.getImageWithURL())
                             .resizable()
                             .frame(width: 50, height: 50, alignment: .center)
                             .cornerRadius(10)
                    }
                    if entry.darkMode! {
                    Text(entry.name).font(.custom("", size: 15))
                        .foregroundColor(.white)

                    Text("$ \(entry.marketPriceUSD.getString())")
                        .font(.title3)
                        .foregroundColor(.white)

                    } else {
                        Text(entry.name).font(.custom("", size: 15))
                            .foregroundColor(.black)
                        Text("$ \(entry.marketPriceUSD.getString())")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 12) {
                    
                    if entry.change1h < 0 {
                        Text(entry.change1h.removeZerosFromEnd() + "%")
                            .font(.custom("", size: 10))
                            .foregroundColor(.red)
                    } else {
                        Text(entry.change1h.removeZerosFromEnd() + "%")
                            .font(.custom("", size: 10))
                            .foregroundColor(.green)
                    }
                    if entry.change7d < 0 {
                        Text(entry.change7d.removeZerosFromEnd() + "%")
                            .font(.custom("", size: 10))
                            .foregroundColor(.red)
                    } else {
                        Text(entry.change7d.removeZerosFromEnd() + "%")
                            .font(.custom("", size: 10))
                            .foregroundColor(.green)
                    }
                    if entry.change24h < 0 {
                        Text(entry.change24h.removeZerosFromEnd() + "%")
                            .font(.custom("", size: 10))
                            .foregroundColor(.red)
                    } else {
                        Text(entry.change24h.removeZerosFromEnd() + "%")
                            .font(.custom("", size: 10))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(entry:CoinWidgetEntry(date: Date(), icon: "", id: "", marketPriceUSD: 24.258, name: "Bitcoin", change1h: 4444, change24h: 12, change7d: 13, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


