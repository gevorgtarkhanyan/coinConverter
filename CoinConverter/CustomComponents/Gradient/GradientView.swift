//
//  GradientView.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/18/19.
//

import UIKit

class GradientView: BaseView {
    
    private lazy var gradient: GradientLayer = {
        let gradient = GradientLayer(frame: self.bounds)
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         self.setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
         self.setup()
    }

    private func setup() {
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.setToFrame(frame: bounds)
//        layer.addSublayer(gradient)
    }
    
}
