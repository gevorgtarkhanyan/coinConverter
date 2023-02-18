//
//  CoinInfoTableViewCell.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

class CoinInfoTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: BaseLabel!
    @IBOutlet weak var valueLabel: BaseLabel!
    
    static let height: CGFloat = 28
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCoinInfo(with data: [CoinInfoDataModel], for indexPath: IndexPath) {
        let currentData = data[indexPath.row - 1]
        nameLabel.text = currentData.name.localized()
        valueLabel.text = currentData.value
        
        setupInterface(for: currentData, with: data)
        backgroundColor = darkMode ? .designBlack : .white
    }
    
    private func setupInterface(for currentData: CoinInfoDataModel, with data: [CoinInfoDataModel]) {
        let lastIndex = data.count - 1
        if data.count != 0 {
            if currentData === data[lastIndex] {
                roundCorners([.bottomLeft, .bottomRight], radius: Constants.radius)
            } else {
                roundCorners([.bottomLeft, .bottomRight], radius: 0)
            }
        }
    }
    
}
