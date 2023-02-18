//
//  Loading.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 23.06.21.
//

import UIKit

class Loading: NSObject {

    // MARK: - Properties
    private var loadingView = LoadingView()
    
    // MARK: - Static
    static let shared = Loading()
    
    // MARK: - Init
    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Methods
    func startLoadingForView(with view: UIView) {
        DispatchQueue.main.async {
            view.addSubview(self.loadingView)
            view.bringSubviewToFront(self.loadingView)
            self.loadingView.setParentView(with: view)
            self.loadingView.startAnimation()
        }
    }
    
    func startLoading(ignoringActions: Bool = false, for view: UIView = UIView(), views: [UIView] = [], barButtons: [UIBarButtonItem] = []) {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                self.startLoadingForView(with: keyWindow)
            }
            
            if ignoringActions {
                view.isUserInteractionEnabled = false
                
                if views.count != 0 {
                    for view in views {
                        view.isUserInteractionEnabled = false
                    }
                }
                
                if barButtons.count != 0 {
                    for button in barButtons {
                        button.isEnabled = false
                    }
                }
            }
        }
    }

    func endLoading(for view: UIView = UIView(), views: [UIView] = [], barButtons: [UIBarButtonItem] = []) {
        loadingView.stopLoading()
        loadingView.removeFromSuperview()
        view.isUserInteractionEnabled = true
        if views.count != 0 {
            for view in views {
                view.isUserInteractionEnabled = true
            }
        }
        
        if barButtons.count != 0 {
            for button in barButtons {
                button.isEnabled = true
            }
        }
    }
}
