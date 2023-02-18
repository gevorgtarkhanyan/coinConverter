//
//  GradientLabel.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 08.07.21.
//

import Foundation
import UIKit

class GradientLabel: UIView {

    weak var label: UILabel!
    var startColor: UIColor = .blue
    var endColor: UIColor = .black
    var duration: CFTimeInterval = 2.0
    var repeatCount: Float = Float.infinity
    var completion: ((Bool) -> Void)?

    // CAGradientLayer provide api to work with gradient colors
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]

        gradientLayer.locations = [0.0, 1.0] as [NSNumber]

        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        // Create internal UILabel and setup it as mask in self
        let lbl = UILabel(frame: frame)
        lbl.numberOfLines = 0
        mask = lbl
        label = lbl
        label.textAlignment = .center
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Resize label and gradient layer on self resizing
        label.translatesAutoresizingMaskIntoConstraints = true
        label.frame = bounds
        gradientLayer.frame = bounds
    }
    
    func setup() {
        // Setup actual colors
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
//        // Add Gradient to self layer
        gradientLayer.removeFromSuperlayer()
        layer.addSublayer(gradientLayer)
        label.frame = bounds
        layoutIfNeeded()
//
//        // Create gradient locations changes animation
//        let anim = CABasicAnimation(keyPath: "locations")
//        anim.delegate = self
//        anim.fromValue = [0.0, 0.1]
//        anim.toValue = [1.0, 1.0]
//        anim.duration = duration
//        anim.repeatCount = repeatCount
//        anim.fillMode = .forwards
//        anim.isRemovedOnCompletion = false
//        gradientLayer.removeAllAnimations()
//        gradientLayer.add(anim, forKey: nil)
    }

    func animate() {
//         Setup actual colors
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
        // Add Gradient to self layer
        gradientLayer.removeFromSuperlayer()
        layer.addSublayer(gradientLayer)

        // Create gradient locations changes animation
        let anim = CABasicAnimation(keyPath: "locations")
        anim.delegate = self
        anim.fromValue = [0.0, 0.1]
        anim.toValue = [1.0, 1.0]
        anim.duration = duration
        anim.repeatCount = repeatCount
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        gradientLayer.removeAllAnimations()
        gradientLayer.add(anim, forKey: nil)
    }

}

extension GradientLabel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim as? CAPropertyAnimation)?.keyPath == "locations" {
            // Call completion block to notify about animation completion
            completion?(flag)
        }
    }
}
