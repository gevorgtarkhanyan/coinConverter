//
//  SpinnerButton.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/25/19.
//

import UIKit

@IBDesignable class SpinnerButton: BaseButton {
    
    @IBInspectable open var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = darkMode ? .white : #colorLiteral(red: 0.4039215686, green: 0.4705882353, blue: 0.6039215686, alpha: 1)
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    private lazy var spiner: SpinerLayer = {
        let spiner = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(spiner)
        return spiner
    }()
    
    private let scaleAnimTimingFunction: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    
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

    override func layoutSubviews() {
        super.layoutSubviews()
        self.spiner.setToFrame(self.frame)
    }

    private func setup() {
        self.clipsToBounds  = true
        spiner.spinnerColor = spinnerColor
    }
    
    public func startAnimation() {
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.layer.cornerRadius = self.frame.height / 2
        }) { complated -> Void in
            self.spiner.animate()
        }
    }
    
    public func stopAnimation(with action: Bool = true, revertAfterDelay delay: TimeInterval = 1, completion: (()->Void)? = nil) {
//        let delayToRevert = max(delay, 0.4)
        spiner.stopAnimation()
        
        if action {
            completion?()
        }
    }
    
    private func setOriginalState(complation: (()-> Void)?) {
        spiner.stopAnimation()
        isUserInteractionEnabled = true
        layer.cornerRadius = cornerRadius
    }
    
    private func scaleAnimation(complation: (() -> Void)?, revertDelay: TimeInterval) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        let expandScale = (UIScreen.main.bounds.size.height / frame.size.height) * 2
        
        scaleAnimation.fromValue  = 1
        scaleAnimation.toValue = max(expandScale, 26)
        scaleAnimation.timingFunction = scaleAnimTimingFunction
        scaleAnimation.duration = 0.4
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            complation?()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + revertDelay, execute: {
                self.setOriginalState(complation: nil)
                self.layer.removeAllAnimations()
            })
        }
        
        layer.add(scaleAnimation, forKey: nil)
        
        CATransaction.commit()
    }
}
