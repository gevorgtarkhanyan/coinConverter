//
//  Array_Extension.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 07.02.22.
//

import Foundation

extension Array {
    func customPrefix(n: Int) -> Array {
        return self.prefix(n).map { $0 }
    }
}

