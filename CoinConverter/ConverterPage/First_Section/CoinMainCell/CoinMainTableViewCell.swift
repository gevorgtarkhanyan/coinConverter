//
//  CoinMainTableViewCell.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

class CoinMainTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var coinNameLabel: BaseLabel!
    @IBOutlet weak var coinSymbolLabel: BaseLabel!
    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var borderBottomView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var arrowDownImageView: BaseImageView!
    
    static let height: CGFloat = 50
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        initialSetup()
//    }

    override func initialSetup() {
        super.initialSetup()
        roundCorners([.topLeft, .topRight], radius: Constants.radius)
        imageParentView.layer.cornerRadius = Constants.radius
        borderBottomView.backgroundColor = .separator
        arrowDownImageView.image = UIImage(named: "arrow_down")?.withRenderingMode(.alwaysTemplate)
      }
//    override func changeColors() {
//        super.changeColors()
//    }
//
    func setupMainCoin(_ coin: CoinModel) {
        coinNameLabel.text = coin.name
        coinSymbolLabel.text = coin.symbol
        iconImageView.sd_setImage(with: URL(string: coin.iconPath), placeholderImage: UIImage(named: "empty_icon"))
        backgroundColor = darkMode ? .designBlack : .white
    }
    
}
