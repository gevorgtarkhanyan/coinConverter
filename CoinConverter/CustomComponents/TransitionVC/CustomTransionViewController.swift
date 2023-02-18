//
//  CustomTransionViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/26/19.
//

import UIKit

class CustomTransitionViewController: BaseViewController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self
    }
    
    //MARK: -- Delegate methods
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
}


