//
//  AdsView.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 06.07.21.
//

import Foundation
import UIKit

protocol AdsViewDelegate: AnyObject {
    func goToSubscriptionPage()
    func goToURLAds()
}

class AdsView: BaseView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adsLogoImage: UIImageView!
    @IBOutlet weak var titleLabel: BaseLabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var adsShortDesc: BaseLabel!
    @IBOutlet weak var joinNowButton: UIButton!
    @IBOutlet weak var sponsoredLabel: BaseLabel!
    
    var url = ""

    weak var delegate: AdsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()

//        fatalError("init(coder:) has not been implemented")
    }
    
    override func changeColors() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.colorSetup()
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AdsView", owner: self, options: nil)
        addSubview(contentView)
        initialSetup()
        sponsoredLabel.setLocalizableText("Sponsored")
    }
    
    private func initialSetup() {
        contentView.frame = self.bounds
        contentView.roundCorners(radius: 10)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        autoresizesSubviews = true
    }
    
    private func colorSetup() {
        backgroundColor = .clear
        contentView.backgroundColor = darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleLabel.textColor =  darkMode ? .white : UIColor.black.withAlphaComponent(0.85)
        adsShortDesc.textColor =  darkMode ? .white : UIColor.black.withAlphaComponent(0.85)
        cancelButton.imageView?.tintColor = .startGradient
        joinNowButton.tintColor = .startGradient
        sponsoredLabel.textColor = darkMode ? .lightText : .darkText
    }

    public func setup(_ ads: AdsModel) {
        titleLabel.setLocalizableText(ads.title)
        adsShortDesc.setLocalizableText(ads.shortDesc)
        adsLogoImage.sd_setImage(with:  URL(string: ads.iconPath ), completed: nil)
        joinNowButton.setTitle(ads.btnName, for: .normal)
        cancelButton.addTarget(self, action: #selector(goToSubscriptionPage), for: .touchUpInside)
        url = ads.url
        joinNowButton.addTarget(self, action: #selector(goToURLAds), for: .touchUpInside)
    }

    @objc private func goToSubscriptionPage() {
        delegate?.goToSubscriptionPage()
    }

    @objc private func goToURLAds() {
        delegate?.goToURLAds()
    }
}

