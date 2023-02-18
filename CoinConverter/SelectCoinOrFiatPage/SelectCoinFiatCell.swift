//
//  SelectCoinFiatCell.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import SDWebImage

class SelectCoinFiatCell: BaseTableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var criptoNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var isLockedImage = false
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        initialSetup()
//    }
    
    override func initialSetup() {
        super.initialSetup()
        backgroundColor = .clear
        rankLabel.textColor = darkMode ? .white : .black
        imageParentView.layer.cornerRadius = Constants.radius
    }
    
    public func setup<T: Equatable>(with data: [T], indexPath: IndexPath) {
        let currentData = data[indexPath.row]
        
        if let data = currentData as? CoinModel {
            rankLabel.text = String(data.rank)
            iconImageView.sd_setImage(with: URL(string: data.iconPath), placeholderImage: UIImage(named: "empty_icon"))
            criptoNameLabel.text = data.symbol
        } else if let data = currentData as? FiatModel {
            criptoNameLabel.text = data.currency
            iconImageView.sd_setImage(with: URL(string: data.iconPath), placeholderImage: UIImage(named: "empty_icon"))
        }
    }
}
