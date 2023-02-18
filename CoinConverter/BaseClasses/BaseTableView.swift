//
//  BaseTableView.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        changeColors()
        addObservers()
        
        separatorColor = darkMode ? .black : .white
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        layer.cornerRadius = Constants.radius
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
        backgroundColor = .clear
        indicatorStyle = darkMode ? .black : .white
        separatorColor = darkMode ? .black : .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
