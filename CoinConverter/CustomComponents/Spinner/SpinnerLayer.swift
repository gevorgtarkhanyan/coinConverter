//
//  SpinnerLayer.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/25/19.
//

import UIKit
import Foundation

class SpinerLayer: CAShapeLayer {
    
    var spinnerColor = UIColor.white {
        didSet {
            strokeColor = spinnerColor.cgColor
        }
    }

    init(frame: CGRect) {
        super.init()

        setToFrame(frame)
        setUpInitialValues()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {// very important part
        super.init(layer: layer)
    }

    func setToFrame(_ frame: CGRect) {
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: frame.height,
                            height: frame.height)
        
        let center = CGPoint(x: frame.height / 2,
                             y: bounds.center.y)

        let radius: CGFloat = (frame.height / 2) * 0.5
        let startAngle = 0 - CGFloat.pi / 2
        let endAngle = CGFloat.pi * 2 - CGFloat.pi / 2
        let clockWise = true

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: clockWise).cgPath

        
        self.path = path
    }

    func setUpInitialValues() {
        strokeColor = spinnerColor.cgColor
        fillColor = nil
        lineWidth = 1
        strokeEnd = 0.4
        isHidden = true
    }

    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.isHidden = false
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation.fromValue = 0
            rotateAnimation.toValue = CGFloat.pi * 2
            rotateAnimation.duration = 0.4
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
            rotateAnimation.repeatCount = Float.infinity
            rotateAnimation.fillMode = .forwards
            rotateAnimation.isRemovedOnCompletion = false
            
            self.add(rotateAnimation, forKey: nil)
        })
    }

    func stopAnimation() {
        isHidden = true
        removeAllAnimations()
    }
}

