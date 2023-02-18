//
//  FiatMainTableViewCell.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

class FiatMainTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var fiatNameLabel: BaseLabel!
    @IBOutlet weak var arrowImageView: BaseImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    static let height: CGFloat = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageParentView.layer.cornerRadius = Constants.radius
        arrowImageView.image = UIImage(named: "arrow_down")?.withRenderingMode(.alwaysTemplate)
        
        
    }
    
    public func setupMainFiat(_ fiat: FiatModel) {
        fiatNameLabel.text = fiat.currency
        iconImageView.sd_setImage(with: URL(string: fiat.iconPath), placeholderImage: UIImage(named: "empty_icon"))
        
        backgroundColor = darkMode ? .designBlack : .white
    }
    
    
}
