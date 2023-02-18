//
//  PopUpViewController.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 28.12.21.
//

import UIKit

class PopUpViewController: BaseViewController {
    
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var contentHeightConstraits: NSLayoutConstraint!
    @IBOutlet weak var textLabel: BaseLabel!
    var customBlurEffectView = UIVisualEffectView()
    @IBOutlet weak var circleIcon: UIImageView!
    var contentTopheight: CGFloat?
    var text: String?
    var iconFrame: CGRect?
    @IBOutlet weak var arrowUpTrallingConstraits: NSLayoutConstraint!
    
    
    // MARK: - Static
    static func initializeStoryboard() -> PopUpViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PopUpViewController.name) as? PopUpViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUpData()
        startAnimation()
    }
    
    private func setUpData() {
        contentBackgroundView?.backgroundColor = .black.withAlphaComponent(0.35)
        if #available(iOS 10.0, *) {
            let blurEffect = UIBlurEffect(style: .dark)
            self.circleIcon.translatesAutoresizingMaskIntoConstraints = true
            self.circleIcon?.frame.origin.x = iconFrame!.origin.x - 9
            self.circleIcon.frame.origin.y = iconFrame!.origin.y - contentTopheight! - 9
            self.arrowUpTrallingConstraits.constant = iconFrame!.width - 10
            
            self.customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
            self.customBlurEffectView.frame = self.contentBackgroundView.bounds
            self.contentHeightConstraits?.constant = contentTopheight ?? 0
            self.contentBackgroundView?.addSubview(customBlurEffectView)
            self.contentBackgroundView.sendSubviewToBack(customBlurEffectView)
            self.contentBackgroundView?.layoutIfNeeded()
        }
        self.textLabel?.text = text
    }
    
    private func startAnimation() {
        
        contentBackgroundView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        contentBackgroundView.alpha = 0
   
        UIView.animate(withDuration: 0.5) {
            self.contentBackgroundView?.alpha = 1
            self.contentBackgroundView.transform = CGAffineTransform.identity
        } completion: { (_) in
            UIView.animate(withDuration: 1, delay: 3) {
                self.contentBackgroundView?.alpha = 0
            } completion: { (_) in
                UIView.animate(withDuration: 1) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    public func setDate(contentTopheight: CGFloat?, text: String, iconFrame: CGRect?) {
        self.contentTopheight = contentTopheight
        self.text = text
        self.iconFrame = iconFrame
    }
}
