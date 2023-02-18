//
//  BigSeparatorView.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/31/20.
//
import UIKit

class BigSeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        addObservers()
        changeColors()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }

    @objc private func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }

    @objc public func changeColors() {
        backgroundColor = darkMode ? .backgroundDark : .backgroundLight
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
