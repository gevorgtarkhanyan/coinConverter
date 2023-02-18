//
//  CategorieCollectionViewCell.swift
//  CoinConverter
//
//  Created by Vazgen Hovakimyan on 22.12.21.
//  Copyright © 2021 WitPlex. All rights reserved.
//

import UIKit

class CategorieCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var categoriesLabel: BaseLabel!
    
    static var height: CGFloat = 40
    static var width: CGFloat  = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    func initialSetup() {
        self.roundCorners(radius: 10)
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.endGradient.cgColor
    }
    
    
    func setDate(categoria: String) {
        self.categoriesLabel.text =  categoria
    }
}
