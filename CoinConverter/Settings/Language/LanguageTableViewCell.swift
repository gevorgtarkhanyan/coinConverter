//
//  LanguageTableViewCell.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.08.21.
//

import UIKit

class LanguageTableViewCell: BaseTableViewCell {
    
//    // MARK: - Views
    @IBOutlet fileprivate weak var nameLabel: BaseLabel!
    @IBOutlet fileprivate weak var checkmarkImageView: UIImageView!

    // MARK: - Properties
    fileprivate var indexPath: IndexPath = IndexPath(index: .zero)
    
    // MARK: - Startup
    override func initialSetup() {
        super.initialSetup()
        clipsToBounds = true
        checkmarkImageView.image = UIImage(named: "cell_checkmark")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.isHidden = !selected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkImageView.isHidden = true
        roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
    }
}

// MARK: - Set data
extension LanguageTableViewCell {
    public func setData(name: String, indexPath: IndexPath, last: Bool, roundCorners: Bool = true) {
        self.indexPath = indexPath
        nameLabel.setLocalizableText(name)
        if roundCorners {
            configBackgroundCorner(lastRow: last)
        }
    }
}

// MARK: - Actions
extension LanguageTableViewCell {
    fileprivate func configBackgroundCorner(lastRow: Bool) {
        if indexPath.row == 0 && lastRow {
            roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        } else if indexPath.row == 0 {
            roundCorners([.topLeft, .topRight], radius: 10)
        } else if lastRow {
            roundCorners([.bottomLeft, .bottomRight], radius: 10)
        }
    }
}
