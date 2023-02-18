//
//  ImageParentView.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/26/19.
//

import UIKit
import SDWebImage

class ImageParentView: UIView {
    
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

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = Constants.radius
    }
    
    public func addChildImage(with urlString: String) {
        let imageView = UIImageView(frame: frame)
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: URL(string: urlString), completed: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0).isActive = true
    }   
}
