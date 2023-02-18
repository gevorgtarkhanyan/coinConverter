//
//  AdsModel.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.07.21.
//

import Foundation

class AdsModel: NSObject, Codable {
    
    var title: String
    var id: String
    var image: String
    var thumbnail: String
    var descript: String
    var shortDesc: String
    var btnName: String
    var website: String
    var conpanyName: String
    var url: String
    var impressionUrl: String
    var isNative: Bool = false
    var adsZoneId: String = ""
    var adsZoneName: String = ""
    var showToSubscribed: Bool = false
    var hideDuration: Int = 0


    init(json: NSDictionary) {
        
        self.title = json.value(forKey: "title") as? String ?? ""
        self.id = json.value(forKey: "adId") as? String ?? ""
        self.image = json.value(forKey: "img") as? String ?? ""
        self.thumbnail = json.value(forKey: "thumbnail") as? String ?? ""
        self.descript = json.value(forKey: "description") as? String ?? ""
        self.shortDesc = json.value(forKey: "description_short") as? String ?? ""
        self.btnName = json.value(forKey: "cta_button") as? String ?? ""
        self.website = json.value(forKey: "website") as? String ?? ""
        self.conpanyName = json.value(forKey: "name") as? String ?? ""
        self.url = json.value(forKey: "url") as? String ?? ""
        self.impressionUrl = json.value(forKey: "impressionUrl") as? String ?? ""

        super.init()
    }
    
    init(jsonFromServer: NSDictionary) {
        let json = jsonFromServer

        self.title = json.value(forKey: "title") as? String ?? ""
        self.id = json.value(forKey: "adId") as? String ?? ""
        self.image = json.value(forKey: "img") as? String ?? ""
        self.thumbnail = json.value(forKey: "icon") as? String ?? ""
        self.descript = json.value(forKey: "desc") as? String ?? ""
        self.shortDesc = json.value(forKey: "shortDesc") as? String ?? ""
        self.btnName = json.value(forKey: "btnName") as? String ?? ""
        self.website = json.value(forKey: "website") as? String ?? ""
        self.conpanyName = json.value(forKey: "name") as? String ?? ""
        self.url = json.value(forKey: "url") as? String ?? ""
        self.impressionUrl = json.value(forKey: "impressionUrl") as? String ?? ""

        super.init()
    }
    
    var iconPath: String {
        return isNative ? (Constants.HttpUrlWithoutApi + "images/ads/" + thumbnail) : thumbnail
    }
    
    override init() {
        self.title = ""
        self.id = ""
        self.image = ""
        self.thumbnail = ""
        self.descript = ""
        self.shortDesc = ""
        self.btnName = ""
        self.website = ""
        self.conpanyName = ""
        self.url = ""
        self.impressionUrl = ""
        super.init()
    } 
}
