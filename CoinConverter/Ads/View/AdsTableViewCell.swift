//
//  AdsTableViewCell.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 04.01.22.
//


import UIKit

class AdsTableViewCell: BaseTableViewCell {
    
    
    static var height: CGFloat = 140
    
    // MARK: Awake from NIB
    override func awakeFromNib() {
        super.awakeFromNib()
      //  startupSetup()
    }
}

// MARK: - Set data
extension AdsTableViewCell {
    
    public func setData(view: AdsView) {
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10).isActive = true
        
    }
}


