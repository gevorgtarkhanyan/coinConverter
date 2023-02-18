//
//  ZoneIdsManager.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.07.21.
//

import Foundation
import UIKit


enum ZoneName: String, CaseIterable {
    case converter = "ConverterMain_1"
    case newsMyFeed = "News_MyFeed_1"
    case newsTop = "News_Top_1"
    case newsAll = "News_All_1"
    case newArticle = "News_Article_1"
}

class ZoneIdsManager: NSObject {
    
    // MARK: - Static
    static let shared = ZoneIdsManager()

    //MARK: - FileManager Methods -
    
    public func addZoneIdToFile(_ zoneId: ZoneIdModel) {
        guard let data = zoneId.getJsonData(),
              let directory = getAdsZoneDocumentDirectory() else { return }
        
        do {
            try data.write(to: directory.appendingPathComponent("\(zoneId.id).json"))
        } catch {
            debugPrint("Can't write zoneId model json data to file: \(error.localizedDescription)")
        }
    }
        public func getAdsZoneDocumentDirectory() -> URL? {
            
            let fileManager = FileManager.default
            do {
                let docURL = Constants.fileManagerURL
                let adsZoneUrl = docURL.appendingPathComponent("AdsZones")
                if !fileManager.fileExists(atPath: adsZoneUrl.path) {
                    try fileManager.createDirectory(atPath: adsZoneUrl.path, withIntermediateDirectories: true, attributes: nil)
                }
                return adsZoneUrl
            } catch {
                debugPrint("Can't get docURL: \(error.localizedDescription)")
                return nil
            }
        }
    
    public func removeAdsZoneByFolder() {
        
        guard let urlAdsZone = self.getAdsZoneDocumentDirectory() else { return }
            
            do {
                try FileManager.default.removeItem(atPath: urlAdsZone.path)
            } catch {
                debugPrint("Can't delete saved adsZones: \(error.localizedDescription)")
            }
    }
    public func getAdsZoneFromDirectory() -> [ZoneIdModel] {
        
        guard let urlAdsZone = self.getAdsZoneDocumentDirectory() else { return [] }
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: urlAdsZone, includingPropertiesForKeys: nil)
            var adsZones: [ZoneIdModel] = []
            
            for url in urls {
                let jsonData = try Data(contentsOf: url)
                let adsZone = try JSONDecoder().decode(ZoneIdModel.self, from: jsonData)
                adsZones.append(adsZone)
            }
            return adsZones
        } catch {
            debugPrint("Can't get adsZones from json: \(error.localizedDescription)")
        }
        
        return []
    }
            
}
