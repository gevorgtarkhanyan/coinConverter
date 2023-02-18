//
//  GradientLayer.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/18/19.
//

import UIKit

class GradientLayer: CAGradientLayer {
    
    init(frame: CGRect) {
        super.init()
        initialSetup()
        setToFrame(frame: frame)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        colors = [UIColor.startGradient.cgColor, UIColor.endGradient.cgColor]
        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
        locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
    }
    
    func setToFrame(frame: CGRect) {
        self.frame = frame
    }
}
