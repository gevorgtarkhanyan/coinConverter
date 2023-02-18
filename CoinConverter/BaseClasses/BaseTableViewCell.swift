//
//  BaseTableViewCell.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    public func initialSetup() {
        addObservers()
        changeColors()
        
        selectionStyle = .none
        clipsToBounds = true
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }
    
    @objc private func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }
    
    func changeColors() {
        backgroundColor =  darkMode ? .designBlack: .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
