//
//  SubscriptionButton.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 18.01.22.
//

import UIKit

class SubscriptionButton: BaseButton {
    
    var rightImageView: UIImageView?
    
    private enum ImageType: String {
        case checkmark, upcoming
    }

    public func subscribedSetup() {
        addBorderShadow()
        addImageView(.checkmark)
        DispatchQueue.main.async {
            self.layoutIfNeeded()
//            self.setGradientBackground(startColor: .subscriptionStart, endColor: .subscriptionEnd)
            self.setGradientBackground()
        }
    }

    public func upcomingSetup() {
        addBorderShadow()
        addImageView(.upcoming)
        DispatchQueue.main.async {
            self.layoutIfNeeded()
//            self.setGradientBackground(startColor: .subscriptionStart, endColor: .subscriptionEnd)
            self.setGradientBackground()
        }
    }
    
    public func unSubscribedSetup() {
        layer.borderWidth = 0
        rightImageView?.removeFromSuperview()
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.setGradientBackground()
        }
    }
    
    private func addImageView(_ image: ImageType) {
        rightImageView = BaseImageView(frame: .zero)
        rightImageView?.image = UIImage(named:  image.rawValue)
        rightImageView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightImageView!)
        rightImageView?.contentMode = .center
        
        let leftConstant: CGFloat = image == .checkmark ? -10 : 0
        rightImageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: leftConstant).isActive = true
        rightImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightImageView?.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        let multiplier: CGFloat = image == .checkmark ? 1 : 61/17
        rightImageView?.widthAnchor.constraint(equalTo: rightImageView!.heightAnchor, multiplier: multiplier).isActive = true
    }
    
}
