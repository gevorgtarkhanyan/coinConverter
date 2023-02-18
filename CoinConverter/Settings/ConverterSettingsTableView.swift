//
//  ConverterSettingsTableView.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 07.02.22.
//

import UIKit

class ConverterSettingsTableView: BaseTableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        changeColors()
    }

    override func changeColors() {
        super.changeColors()
        separatorColor = darkMode ? .backgroundDark : .backgroundLight
    }
}
