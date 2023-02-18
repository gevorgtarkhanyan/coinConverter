//
//  CoinFiatTableViewCell.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

class CoinFiatTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var criptoNameLabel: BaseLabel!
    @IBOutlet weak var criptoValueLabel: BaseLabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    static let height: CGFloat = 40
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageParentView.layer.cornerRadius = Constants.radius
    }
    
    public func setupCoin(with data: [CoinModel], for indexPath: IndexPath) {
        let currentCoin = data[indexPath.row]
        criptoNameLabel.text = currentCoin.name
        criptoValueLabel.text = currentCoin.changeAblePrice.getString() + " " + currentCoin.symbol
        iconImageView.sd_setImage(with: URL(string: currentCoin.iconPath), placeholderImage: UIImage(named: "empty_icon"))
        backgroundColor = darkMode ? .designBlack : .white
        setupInterface(for: currentCoin, with: data, indexPath: indexPath)
    }

    public func setupFiat(with data: [FiatModel], for indexPath: IndexPath) {
        let currentFiat = data[indexPath.row]
        criptoNameLabel.text = currentFiat.currency
        criptoValueLabel.text = currentFiat.changeAblePrice.getString() + " " + currentFiat.symbol
        iconImageView.sd_setImage(with: URL(string: currentFiat.iconPath), placeholderImage: UIImage(named: "empty_icon"))
        backgroundColor = darkMode ? .designBlack : .white
        setupInterface(for: currentFiat, with: data, indexPath: indexPath)
    }
    
    private func setupInterface<T: Equatable>(for currentData: T, with data: [T], indexPath: IndexPath) {
        if indexPath.section == 1 {
            if data.count != 0 {
                if currentData == data[0] {
                    roundCorners([], radius:  Constants.radius)
                } else {
                    roundCorners([.topRight, .topLeft], radius: 0)
                }
            }
        } else if indexPath.section == 2 {
            roundCorners([.topRight, .topLeft], radius: 0)
        }
    }
    
}
