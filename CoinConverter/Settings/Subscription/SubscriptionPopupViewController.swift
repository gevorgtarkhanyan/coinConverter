//
//  SubscriptionPopupViewController.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 07.01.22.
//

import UIKit

class SubscriptionPopupViewController: BaseViewController {

    @IBOutlet weak var subscriptionBottmConstraint: NSLayoutConstraint!
    @IBOutlet weak var subscriptionView: SubscriptionView!
    
    static func initializeStoryboard() -> SubscriptionPopupViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SubscriptionPopupViewController.name) as? SubscriptionPopupViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTapGesture()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showSubscriptionView()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction() {
        hideSubscriptionView { _ in
            self.dismiss(animated: false)
        }
    }
    
    //MARK: - Animate
    private func showSubscriptionView() {
        let destinationY = -(view.frame.height / 2 + subscriptionView.frame.height / 2)
        subscriptionView.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.subscriptionView.alpha = 1
            self.subscriptionBottmConstraint.constant = destinationY
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideSubscriptionView(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.subscriptionBottmConstraint.constant = -20
            self.subscriptionView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
}
