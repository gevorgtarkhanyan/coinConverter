//
//  FiatView.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 30.07.21.
//

import WidgetKit
import SwiftUI

struct FiatView : View {
    var entry: FiatProvider.Entry
    
    var body: some View {
        
        ZStack {
            if entry.darkMode! {
                Color(red: 38/255, green: 45/255, blue: 57/255)
            } else {
                Color(red: 244/255, green: 244/255, blue: 244/255)
            }
            VStack(alignment: .center,spacing: 8) {
                VStack(alignment: .center,spacing: 6)  {
                    if entry.icon != "" {
                        Image(uiImage: entry.icon.getImageWithURL())
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(10)
                    }
                    
                    if entry.darkMode! {
                        Text(entry.name).font(.custom("", size: 14))
                            .foregroundColor(.white)
                        
                        HStack(alignment: .center, spacing: 5) {
                            if entry.fiatIcon != "" {
                                Image(uiImage: entry.fiatIcon.getImageWithURL())
                                    .resizable()
                                    .frame(width: 18, height: 18, alignment: .center)
                                    .cornerRadius(10)
                            }
                            Text(entry.fiatPrice.getString())
                                .font(.custom("", size: 12))
                                .foregroundColor(.white)
                        }
                        if entry.fiat2Price != nil {
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                                if entry.fiat2Icon != "" {
                                    Image(uiImage: entry.fiat2Icon!.getImageWithURL())
                                        .resizable()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .cornerRadius(10)
                                }
                                Text(entry.fiat2Price!.getString())
                                    .font(.custom("", size: 12))
                                    .foregroundColor(.white)
                            }
                        }
                        if entry.fiat3Price != nil {
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                                if entry.fiat2Icon != "" {
                                    Image(uiImage: entry.fiat3Icon!.getImageWithURL())
                                        .resizable()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .cornerRadius(10)
                                }
                                Text(entry.fiat3Price!.getString())
                                    .font(.custom("", size: 12))
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        Text(entry.name).font(.custom("", size: 14))
                            .foregroundColor(.black)
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                            if entry.fiatIcon != "" {
                                Image(uiImage: entry.fiatIcon.getImageWithURL())
                                    .resizable()
                                    .frame(width: 18, height: 18, alignment: .center)
                                    .cornerRadius(10)
                            }
                            Text(entry.fiatPrice.getString())
                                .font(.custom("", size: 12))
                                .foregroundColor(.black)
                        }
                        if entry.fiat2Price != nil {
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                                if entry.fiat2Icon != "" {
                                    Image(uiImage: entry.fiat2Icon!.getImageWithURL())
                                        .resizable()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .cornerRadius(10)
                                }
                                Text(entry.fiat2Price!.getString())
                                    .font(.custom("", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                        if entry.fiat3Price != nil {
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                                if entry.fiat2Icon != "" {
                                    Image(uiImage: entry.fiat3Icon!.getImageWithURL())
                                        .resizable()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .cornerRadius(10)
                                }
                                Text(entry.fiat3Price!.getString())
                                    .font(.custom("", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                
            }
        }
    }
}

struct FiatView_Previews: PreviewProvider {
    static var previews: some View {
        FiatView(entry: FiatWidgetEntry(date: Date(), icon: "", fiatIcon: "", fiat2Icon: "", fiat3Icon: "", fiatPrice: 0, fiat2Price: 0, fiat3Price: 0, name: "", darkMode: true, configuration: FiatConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


