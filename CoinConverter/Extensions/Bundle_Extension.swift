//
//  Bundle_Extension.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 2/3/20.
//

import UIKit

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
