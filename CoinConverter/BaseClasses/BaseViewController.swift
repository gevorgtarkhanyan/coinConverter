//
//  BaseViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import Localize_Swift

class BaseViewController: UIViewController {
    
    // MARK: - Views
    fileprivate var noDataLabel: BaseLabel?
    fileprivate var maskView: MaskView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageChanged()
        addObservers()
        changeColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
   
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name(LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
    }
    
    @objc public func keyboardWillHide(_ sender: Notification) { }
    @objc public func keyboardWillShow(_ sender: Notification) { }
    
    @objc public func criptoDownloadSuccessfully() {}
    @objc public func criptoDownloadFailed() {}
    
    @objc public func willEnterForeground() {}
    @objc public func languageChanged() {}
    
    @objc func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }
    
    private func changeColors() {
        view.backgroundColor = darkMode ? .backgroundDark : .backgroundLight
    }
    
   @objc public func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func hidePage() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func openURL(urlString: String) {
        if let copyRightURL = URL(string: urlString), UIApplication.shared.canOpenURL(copyRightURL) {
            openUrl(url: copyRightURL)
        }
    }
    
    func openUrl(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    public func showNoDataLabel(with text: String = "no_items_available".localized()) {
        DispatchQueue.main.async {
            self.addNoDataLabelToView(text: text)
        }
    }
    
    fileprivate func addNoDataLabelToView(text: String) {
        guard noDataLabel == nil else { return }
        noDataLabel = BaseLabel(frame: .zero)
        noDataLabel?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataLabel!)
        
        noDataLabel?.setLocalizableText(text)
        
        noDataLabel?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noDataLabel?.changeFontSize(to: 14)
    }
    
    public func hideNoDataLabel() {
        DispatchQueue.main.async {
            self.noDataLabel?.removeFromSuperview()
            self.noDataLabel = nil
        }
    }
    
    public func showWarningAlert(title: String? = "Just selected", message: String? = "Choose another \(CriptoType.coin.rawValue)", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    @objc public func showSubscriptionPopup() {
        guard let vc = ManageSubscriptionViewController.initializeStoryboard() else { return }
//        vc.setPopup(true)
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: false, completion: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
