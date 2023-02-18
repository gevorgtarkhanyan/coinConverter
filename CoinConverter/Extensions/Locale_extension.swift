//
//  Locale_extension.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 15.01.22.
//

import Foundation

extension Locale {
    static var subscriptionLocale: Locale? {
        Defaults.loadDefaults(key: .subscriptrionLocale)
    }
}
