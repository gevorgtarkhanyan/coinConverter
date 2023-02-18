//
//  For_UIView.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit

fileprivate var gesturs = [UIGestureRecognizer]()

extension UIView {
    func addSeparatorView(from firstItem: UIView? = nil, to secondItem: UIView? = nil) {
        let separatorView = UIView(frame: .zero)
        separatorView.backgroundColor = .separator
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        if firstItem != nil, secondItem != nil {
            separatorView.rightAnchor.constraint(equalTo: secondItem!.rightAnchor).isActive = true
            separatorView.leftAnchor.constraint(equalTo: firstItem!.leftAnchor).isActive = true
        } else {
            separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
        
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight).isActive = true
    }
    
    func setGradientBackground(startColor: UIColor = .startGradient, endColor: UIColor = .endGradient){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = bounds
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(_ corners: CACornerMask = [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: CGFloat = 10) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)) {
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)) {
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)) {
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)) {
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func showAsCircle() {
        layer.cornerRadius = CGFloat(self.frame.width / 4)
    }
    
    func addEqualRatioConstraint() {
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
    }
    
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func inParentView(_ bcolor: UIColor? = .clear) -> UIView {
        let parentView = UIView(frame: self.bounds)
        parentView.backgroundColor = bcolor
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        parentView.layoutIfNeeded()
        return parentView
    }
    
    public func addGestures(target: AnyObject?, action: Selector?) {
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        addGestureRecognizer(getSwipeGesture(for: .down, target: target, action: action))
        addGestureRecognizer(getSwipeGesture(for: .up, target: target, action: action))
        addGestureRecognizer(getSwipeGesture(for: .left, target: target, action: action))
        addGestureRecognizer(getSwipeGesture(for: .right, target: target, action: action))

        let tap = UITapGestureRecognizer(target: target, action: action)
        let swipeDown = getSwipeGesture(for: .down, target: target, action: action)
        let swipeUp = getSwipeGesture(for: .up, target: target, action: action)
        let swipeLeft = getSwipeGesture(for: .left, target: target, action: action)
        let swipeRight = getSwipeGesture(for: .right, target: target, action: action)
        gesturs = [tap, swipeDown, swipeUp, swipeLeft, swipeRight]
    }
    
    public func removeGestures() {
        let views = getAllSubviews() + [self]
        for view in views {
            gesturs.forEach { view.removeGestureRecognizer($0) }
        }
        gesturs.removeAll()
    }

    private func getSwipeGesture(for direction: UISwipeGestureRecognizer.Direction, target: AnyObject?, action: Selector?) -> UISwipeGestureRecognizer {
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: target, action: action)
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizer.direction = direction
        return swipeGestureRecognizer
    }
    
}

//MARK: - Point
extension UIView {
    public var globalPoint: CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    public var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    public var alertPoint: CGPoint? {
        guard let globalFrame = globalFrame, let globalPoint = globalPoint else { return nil }
        let x = globalPoint.x + globalFrame.width / 2
        let y = globalPoint.y + globalFrame.height
        
        return CGPoint(x: x, y: y)
    }
}

extension UIView {
    func addShadow(opacity: Float? = nil, cgRect: CGRect? = nil) {
        layer.masksToBounds = false
        layer.shadowColor =  darkMode ? #colorLiteral(red: 0.6431372549, green: 0.862745098, blue: 1, alpha: 1) : #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.2196078431, alpha: 1)
        layer.shadowOpacity = opacity ?? 0.12
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowPath = UIBezierPath(rect: cgRect ?? self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addBorderShadow() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.startGradient.cgColor
        addShadow()
    }
}


extension UIView {
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get<T: UIView>(all type: T.Type) -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get(all types: [UIView.Type]) -> [UIView] { return UIView.getAllSubviews(from: self, types: types) }
}
