//
//  AddCoinFiatTableViewCell.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

protocol AddCoinFiatTableViewCellDelegate: AnyObject {
    func plusTapped(section: Int)
}

class AddCoinFiatTableViewCell: BaseTableViewCell {

    @IBOutlet weak var plusButton: GradientButton!
    
    weak var delegate: AddCoinFiatTableViewCellDelegate?

    static let height: CGFloat = 40
    private var indexPath: IndexPath?
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        initialSetup()
//    }
    
    override func initialSetup() {
        super.initialSetup()
        if let imageView = plusButton.imageView {
            plusButton.bringSubviewToFront(imageView)
        }
    }
    
    @IBAction func plusTapped() {
        if let delegate = delegate {
            if let indexPath = indexPath {
                delegate.plusTapped(section: indexPath.section)
            }
        }
    }
    
    func setup(for indexPath: IndexPath) {
        self.indexPath = indexPath
        if indexPath.section == 2 {
            roundCorners([.bottomRight, .bottomLeft], radius: Constants.radius)
        } else if indexPath.section == 1 {
            roundCorners([], radius: 0)
            addSeparatorView()
        }
        backgroundColor = darkMode ? .designBlack : .white
    }
    
    
}
