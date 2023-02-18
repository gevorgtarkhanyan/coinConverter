//
//  ZoneIdModel.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.07.21.
//

import UIKit

class ZoneIdModel: NSObject, Codable {
    
   var native: Bool = false
   var enabled: Bool = false
   var track: Bool = false
   var id: String = ""
   var name: String = ""
   var showToSubscribed: Bool = false
   var hideDuration: Int = 0
   var zones:[[String: String]] = [[:]]
     
    
    override init() {
        super.init()
    }
    
    init(json: NSDictionary?) {
        let json = json ?? NSDictionary()
        
        self.native = json.value(forKey: "native") as? Bool ?? false
        self.enabled = json.value(forKey: "enabled") as? Bool ?? false
        self.track = json.value(forKey: "track") as? Bool ?? false
        self.id = json.value(forKey: "_id") as? String ?? ""
        self.name = json.value(forKey: "name") as? String ?? ""
        self.showToSubscribed = json.value(forKey: "showToSubscribed") as? Bool ?? false
        self.hideDuration = json.value(forKey: "hideDuration") as? Int ?? 0
        self.zones = json.value(forKey: "zones") as? [[String:String]] ?? [[:]]
    }
    
    public func getJsonData() -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch {
            debugPrint("Can't convert notification model to json: \(error.localizedDescription)")
        }
        return nil
    }
}
