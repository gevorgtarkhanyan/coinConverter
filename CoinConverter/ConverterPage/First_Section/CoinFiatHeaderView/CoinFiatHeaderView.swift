//
//  CoinFiatHeaderView.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

protocol CoinFiatHeaderViewDelegate: AnyObject {
    func reverse()
}

class CoinFiatHeaderView: BaseView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var firstLabel: BaseLabel!
    @IBOutlet weak var secondLabel: BaseLabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var separatorView: BigSeparatorView!
    
    static var height: CGFloat = 56 // must be more than 40px, the rest is distance from surrounding
    public var reversed = false
    
    weak var delegate: CoinFiatHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    override func changeColors() {
        let image = UIImage(named: "converter")?.withRenderingMode(.alwaysTemplate)
        iconImageView?.image = image
        iconImageView?.tintColor = darkMode ? .white : .black
    }
    
    private func addGestureToGradient() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(reverseCoinFiat))
        gradientView.addGestureRecognizer(tap)
    }
   
    @objc private func reverseCoinFiat() {
        delegate?.reverse()
    }
    
    public func setupData(_ reversed: Bool) {
        if reversed {
            firstLabel.text = "fiat".localized()
            secondLabel.text = "coin".localized()
        } else {
            firstLabel.text = "coin".localized()
            secondLabel.text = "fiat".localized()
        }
    }
    
    private func initialSetup() {
        firstLabel.text = "coin".localized()
        secondLabel.text = "fiat".localized()
        changeColors()
    }
    
     func addRotateAnimation() {
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = 0
        rotateAnim.toValue = 2 * CGFloat.pi
        rotateAnim.duration = 2
        rotateAnim.fillMode = .forwards
        rotateAnim.repeatCount = .infinity
        
        iconImageView.layer.add(rotateAnim, forKey: nil)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CoinFiatHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initialSetup()
        addRotateAnimation()
        addGestureToGradient()
    }
    
}
