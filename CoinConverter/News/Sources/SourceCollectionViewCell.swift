//
//  SourceCollectionViewCell.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 27.12.21.
//

import UIKit
import SDWebImage

protocol SourceCollectionViewCellDelegate: AnyObject {
    func plusAction (indexPath: IndexPath)
    func minusAction (indexPath: IndexPath)
}

class SourceCollectionViewCell: BaseCollectionViewCell {
    
    //Views
    @IBOutlet weak var sourceIcon: BaseImageView!
    @IBOutlet weak var sourceLabel: BaseLabel!
    @IBOutlet weak var plusMinusButton: BaseButton!
    @IBOutlet weak var imageBackgorundView: UIView!
    
    var indexPath: IndexPath?
    weak var delegate: SourceCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.plusMinusButton.removeTarget(self, action: #selector(plusAction), for: .touchUpInside)
        self.plusMinusButton.removeTarget(self, action: #selector(minusAction), for: .touchUpInside)
    }
    
    func initialSetup() {
        self.roundCorners(radius: 10)
        self.imageBackgorundView.roundCorners(radius: 10)
        self.imageBackgorundView.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.6823529412, blue: 0.7450980392, alpha: 1)
        self.addShadow()
    }
    
    
    func setData(sourceName:String, indexPath: IndexPath , isAdded: Bool) {
        
        self.indexPath = indexPath
        
        self.sourceLabel.setLocalizableText(sourceName)
        let imageURL = Constants.HttpNewsUrl + ("images/sources/") + sourceName + ".png"
        self.sourceIcon.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "news_placeholder"), completed: nil)
        if isAdded {
            self.plusMinusButton.setImage(UIImage(named: "source_minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.plusMinusButton.tintColor = darkMode ? .white : .black
            self.plusMinusButton.addTarget(self, action: #selector(minusAction), for: .touchUpInside)
            
        } else {
            self.plusMinusButton.setImage(UIImage(named: "source_plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.plusMinusButton.tintColor = .endGradient
            self.plusMinusButton.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        }
    }
    
    // MARK: - Delegate Methods-
    @objc func plusAction() {
        if let delegate = delegate, let indexPath = indexPath {
            delegate.plusAction(indexPath: indexPath)
        }
    }
    @objc func minusAction() {
        if let delegate = delegate, let indexPath = indexPath {
            delegate.minusAction(indexPath: indexPath)
        }
    }
}
