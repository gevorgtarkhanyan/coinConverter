//
//  UITabBar_Extension.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 16.12.21.
//

import UIKit

@available(iOS 13.0, *)
@IBDesignable
class ConvertorTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    let gradientlayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObservers()
    }
    
    override func draw(_ rect: CGRect) {
        self.addShapeForConvertor()
    }
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addShapeForConvertor), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
    }
    
    @objc private func addShapeForConvertor() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowPath = CGPath(rect: self.bounds,
                                       transform: nil)
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = darkMode ? #colorLiteral(red: 0.6431372549, green: 0.862745098, blue: 1, alpha: 1) : #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.2196078431, alpha: 1)
        shapeLayer.shadowOpacity = 0.12
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    

    func createPath() -> CGPath {
        let height: CGFloat = 76.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
        path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
        
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 74
//        return sizeThatFits
//    }
//}
