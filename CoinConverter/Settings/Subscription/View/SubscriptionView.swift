//
//  SubscriptionView.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 07.01.22.
//

import UIKit

class SubscriptionView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var purchaseInfoLabel: GradientLabel!
    @IBOutlet weak var purchaseProLabel: BaseLabel!

    @IBOutlet weak var monthlyButton: GradientButton!
    @IBOutlet weak var yearlyButton: GradientButton!
    @IBOutlet weak var saveLabel: BaseLabel!
    @IBOutlet weak var restoreButton: GradientButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(SubscriptionView.name, owner: self, options: nil)
        
        addSubview(contentView)
        backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.roundCorners(radius: Constants.radius)
        contentView.backgroundColor = darkMode ? .barDark : .white
        setup()
    }
    
    private func setup() {
        setupPurchaseInfoLabel()
        
        purchaseProLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        let tintColor: UIColor = darkMode ? .white : .black
        monthlyButton.setTitleColor(tintColor, for: .normal)
        yearlyButton.setTitleColor(tintColor, for: .normal)
    }
    
    private func setupPurchaseInfoLabel() {
        purchaseInfoLabel.label.text = "subscription_info".localized()//"Unlimited access to all coins and foreign exchange"
        purchaseInfoLabel.startColor = .startGradient
        purchaseInfoLabel.endColor = .endGradient
        purchaseInfoLabel.setup()
    }
    
}
