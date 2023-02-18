//
//  SourceModel.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 24.12.21.
//

import UIKit

class SourceModel: NSObject {
    
    var added: [String] = []
    var all: [String] = []
    
    override init() {
        super.init()
    }
    
    init(json: NSDictionary?) {
        let json = json ?? NSDictionary()
        
        self.added = json.value(forKey: "added") as? [String] ?? []
        self.all = json.value(forKey: "all") as? [String] ?? []
    }
}
