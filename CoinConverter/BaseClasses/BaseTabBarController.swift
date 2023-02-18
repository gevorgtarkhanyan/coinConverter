//
//  BaseTabBarController.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 16.12.21.
//

import UIKit


class BaseTabBarController: UITabBarController {
    let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 76, height: 76))
    var customBlurEffectView = UIVisualEffectView()

    // Change status bar text color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .default
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(menuButton)
        setSizeMiddleButton(size: self.view.frame.size)
        if #available(iOS 10.0, *) {
            customBlurEffectView.removeFromSuperview()
            setupBlureView()
        }
    }
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeColors), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationOpenedFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    @objc func applicationOpenedFromBackground(_ sender: Notification) {
        
        if selectedIndex == 0 {
            guard !isNewsContentControllerAppeared() else { return }
            NotificationCenter.default.removeObserver(viewControllers?[selectedIndex].children.first as Any)
            TabBarRuningPage.shared.changeLastPage(to: .news)
            guard let newsVC = NewsPageController.initializeStoryboard() else { return }
            NewsCacher.shared.removeNewsData()
            let navVC = BaseNavigationController(rootViewController: newsVC)
            viewControllers?[selectedIndex] = navVC
            tabBar.items?[selectedIndex].image = UIImage(named: "news")?.withRenderingMode(.automatic)
        }
        if selectedIndex == 1 {
            NotificationCenter.default.removeObserver(viewControllers?[selectedIndex].children.first as Any)
            TabBarRuningPage.shared.changeLastPage(to: .convertor)
            guard let convertorVC = ConverterViewController.initializeStoryboard() else { return }
            let navVC = BaseNavigationController(rootViewController: convertorVC)
            viewControllers?[selectedIndex] = navVC
        }
    }
    
    private func isNewsContentControllerAppeared() -> Bool {
        guard let newsVC = viewControllers?[0] else { return false }
        guard let navigation = newsVC as? BaseNavigationController else { return  false }
        if navigation.viewControllers.count > 1, let vc = navigation.viewControllers.last {
            if let contentVC = vc as? NewsContentViewController {
                if contentVC.isViewLoaded {
                    return true
                }
            }
        }
        return  false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        changeColors()
        
        selectedIndex = 1
    
        setupMiddleButton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setWidthBlureView(widht: size.width)
    }
    
    
    func setupMiddleButton() {

        menuButton.setImage(UIImage(named: "tabBar_button_light"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
    }
    
    
    func setSizeMiddleButton(size: CGSize) {
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = size.height - tabBar.frame.height - 38
        menuButtonFrame.origin.x = size.width / 2 - menuButtonFrame.size.width / 2
        menuButton.frame = menuButtonFrame
                
        menuButton.layer.cornerRadius = menuButtonFrame.height / 2
        view.layoutIfNeeded()
    }

    @objc fileprivate func changeColors() {
        tabBar.barStyle = darkMode ? .black : .default
        tabBar.isTranslucent = true
        tabBar.barTintColor = darkMode ? .barDark : .barLight
        tabBar.tintColor = darkMode ? .endGradient : .startGradient
        tabBar.layoutIfNeeded()
        menuButton.setImage(UIImage(named: darkMode ? "tabBar_button" : "tabBar_ligthButton"  ), for: .normal)

        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        }
    }
    
    // MARK: - Actions
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 1
        guard let vc = ConverterViewController.initializeStoryboard() else { return }
        let navVC = BaseNavigationController(rootViewController: vc)
        tabBarController(self, didSelect: navVC)
    }

    @available(iOS 10.0, *)
        func setupBlureView() {
            let blurEffect = UIBlurEffect(style: .dark )
            customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
            
            customBlurEffectView.frame = self.tabBar.frame
            self.view.insertSubview(customBlurEffectView, belowSubview: self.tabBar)
            

            self.view.layoutIfNeeded()
        }
    func setWidthBlureView(widht: CGFloat) {
        self.customBlurEffectView.frame.size.width = widht
        self.tabBar.layoutIfNeeded()
    }
}

// MARK: - TabBar delegate for animation switch
extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransition(viewControllers: tabBarController.viewControllers)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        AlamofireManager.shared.cancelTask(urlPath: "adverts/params")
//        AlamofireManager.shared.cancelTask(urlPath: Constants.HttpsCoinzilla)
        
        menuButton.setImage(UIImage(named: selectedIndex == 1 ? "tabBar_button_light" : darkMode ? "tabBar_button" : "tabBar_ligthButton"  ), for: .normal)
        
        guard let navigation = viewController as? BaseNavigationController else { return }
        if navigation.viewControllers.count > 1, let vc = navigation.viewControllers.last {
            vc.navigationController?.popToRootViewController(animated: false)
        }
        guard let newVC = navigation.viewControllers.first else { return }
        
        guard selectedIndex != TabBarRuningPage.shared.lastSelectedPage.rawValue else {
            return
        }
        
        if let newsPag = newVC as? NewsPageController {
            if newsPag.isViewLoaded {
                NewsCacher.shared.removeNewsData()
                newsPag.refreshPage(nil)
            }
            TabBarRuningPage.shared.changeLastPage(to: .news)
        }
        
        if let convertrVC = newVC as? ConverterViewController {
            TabBarRuningPage.shared.changeLastPage(to: .convertor)
            if convertrVC.isViewLoaded {
                convertrVC.refreshPage()
            }
        }
        
        if let _ = newVC as? ConverterSettingsViewController {
            TabBarRuningPage.shared.changeLastPage(to: .settings)
        }
        
    }
}

@available(iOS 10.0, *)
final class CustomVisualEffectView: UIVisualEffectView {
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
    
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
}
