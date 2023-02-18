//
//  LoadingView.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/21/20.
//

import UIKit

@IBDesignable class LoadingView: UIView {
    
    static let width = Constants.loadingHeight
    
//    @IBInspectable open var spinnerColor: UIColor = UIColor.white {
//        didSet {
//            spiner.spinnerColor = spinnerColor
//        }
//    }
    
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
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialValues()
    }
    
    private func setupInitialValues() {
        clipsToBounds = true
        isHidden = false
        spiner.spinnerColor = darkMode ? .white : .black
    }
    
    public func startAnimation(for view: UIView? = nil) {
        spiner.spinnerColor = darkMode ? .white : .black
        spiner.animate()
        if let view = view {
            view.isUserInteractionEnabled = false
        }
    }
    
    public func stopLoading(for view: UIView? = nil) {
        if let view = view {
            view.isUserInteractionEnabled = true
        }
        spiner.stopAnimation()
    }
    
    public func setParentView(with view: UIView) {
        let size = view.frame.size
        let laodingWidth = LoadingView.width
        let midX = size.width / 2 - laodingWidth / 2
        let midY = size.height / 2 - laodingWidth / 2
        
        self.frame = CGRect(x: midX,
                            y: midY,
                            width: laodingWidth,
                            height: laodingWidth)
    }
}
