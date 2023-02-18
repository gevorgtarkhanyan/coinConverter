//
//  ManageSubscriptionViewController.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/27/20.
//

import UIKit
import StoreKit

class ManageSubscriptionViewController: BaseViewController {
    
    @IBOutlet weak var subscriptionView: UIView!
    
    @IBOutlet weak var promoImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subscriptionViewBottmConstraint: NSLayoutConstraint!
    @IBOutlet weak var subscriptionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var purchaseInfoLabel: BaseLabel!

    @IBOutlet weak var monthlyButton: SubscriptionButton!
    @IBOutlet weak var yearlyButton: SubscriptionButton!
    @IBOutlet weak var saveLabel: BaseLabel!
    @IBOutlet weak var restoreButton: BaseButton!
    
    @IBOutlet weak var infoTextView: BaseTextView!
    @IBOutlet weak var privacyPolicy: UIButton!
    @IBOutlet weak var termsOfUse: UIButton!
    
    @IBOutlet weak var textSpaceConstraint: NSLayoutConstraint!
//    @IBOutlet weak var privacyPolisyViewTopConstraint: NSLayoutConstraint!
    
    private var products: [Subscription]?
    private var noWiFyIcon: UIBarButtonItem!
    private var privacyViewHeight: CGFloat = 44
    
    fileprivate var isPopup = false
    
    static func initializeStoryboard() -> ManageSubscriptionViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ManageSubscriptionViewController.name) as? ManageSubscriptionViewController
    }
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        fetchProductInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showInternetIcon()
        showSubscriptionPopUp()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.setViewConstraint(to: size)
        setupInterfeceDependOnSubscription()
    }

    //MARK: - Setup
    private func initialSetup() {
        setup()
        if isPopup {
            popupSetup()
        } else {
            defaultSetup()
        }
    }
    
    private func defaultSetup() {
        setupNavigation()
    }
    
    private func setupNavigation() {
        title = "manage_subscription".localized()
        noWiFyIcon = UIBarButtonItem(image: UIImage(named: "no_wifi"), style: .done, target: self, action: nil)
    }
    
    private func setup() {
        StoreManager.shared.delegate = self
        StoreObserver.shared.delegate = self
        
        self.promoImageView.isHidden = !Defaults.bool(key: .isPromo)
        setTitles()
        setupInterfeceDependOnSubscription()
        setupPurchaseInfoLabel()
        infoTextView.verticalIdicatorColor = .startGradient
        subscriptionView.layer.cornerRadius = Constants.radius
        restoreButton.addBorderShadow()
    }
    
    fileprivate func setupInterfeceDependOnSubscription() {
        let id = Defaults.load(key: .subscriptionType) ?? ""
        if id.contains("yearly") {
            yearlyButton.isEnabled = false
            yearlyButton.subscribedSetup()
            if let id = IAPHelper.sharedInstance.pandingInfo?.autoRenewId, id.contains("monthly") {
                monthlyButton.isEnabled = false
                monthlyButton.upcomingSetup()
            } else {
                monthlyButton.isEnabled = true
                monthlyButton.unSubscribedSetup()
            }
        } else if id.contains("monthly") {
            monthlyButton.isEnabled = true
            yearlyButton.isEnabled = true
            monthlyButton.subscribedSetup()
            yearlyButton.unSubscribedSetup()
        } else {
            monthlyButton.isEnabled = true
            yearlyButton.isEnabled = true
            monthlyButton.unSubscribedSetup()
            yearlyButton.unSubscribedSetup()
        }
    }
    
    private func setupPurchaseInfoLabel() {
        purchaseInfoLabel.text = "subscription_info".localized()
        purchaseInfoLabel.textAlignment = .center
        purchaseInfoLabel.lineBreakMode = .byWordWrapping
        purchaseInfoLabel.numberOfLines = 2
    }
    
    //MARK: - Actions
    private func setTitles() {
        var monthText = " / " + "month".localized()
        var yearText = " / " + "year".localized()
        let prices = getPrices()
        let savings = prices.monthlyPrice.calculateSavings(with: prices.yearlyPrice)

        monthText.add(prefix: prices.monthlyPrice.formatWithCurrency(locale: Locale.subscriptionLocale) ?? "")
        yearText.add(prefix: prices.yearlyPrice.formatWithCurrency(locale: Locale.subscriptionLocale) ?? "")
        monthlyButton.setTitle(monthText, for: .normal)
        yearlyButton.setTitle(yearText, for: .normal)
        
        var subscriptionSave = "subscription_save".localized()
        subscriptionSave = subscriptionSave.replacingOccurrences(of: "percent", with: savings.percent.getFormatedString())
        subscriptionSave = subscriptionSave.replacingOccurrences(of: "newMonthlyCost", with: savings.formatedNewMonthlyCost)
        saveLabel.text = subscriptionSave//"(Save \(savings.percent)%. 12 monts at \(savings.formatedNewMonthlyCost)/mo)"
        saveLabel.changeFontSize(to: 12)
        restoreButton.setTitleKey("restore")
        infoTextView.setTitleKey("subscription_text", size: 10)
        privacyPolicy.setTitle("privacy_policy".localized(), for: .normal)
        termsOfUse.setTitle("terms_of_use".localized(), for: .normal)
    }
    
    private func getPrices() -> (monthlyPrice: Double, yearlyPrice: Double) {
        let monthlyPrice = products?.first?.price ?? Defaults.load(key: .productPriceMonthly) ?? 0.0
        let yearlyPrice = products?.last?.price ?? Defaults.load(key: .productPriceYearly) ?? 0.0
        return (monthlyPrice: monthlyPrice, yearlyPrice: yearlyPrice)
    }

    private func showInternetIcon() {
        if Connectivity.shared.isConnectedToInternet() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = noWiFyIcon
        }
    }
    
    private func setViewConstraint(to size: CGSize) {
        
        
        textSpaceConstraint.constant = 20
        let height = size.height - self.contentView.frame.height - 60
        
        self.textSpaceConstraint.constant = height > 60 ? height : 20
        
        self.subscriptionViewWidthConstraint.constant = self.isPopup ? size.width * 0.7 : size.width - 32
    }
    
    private func tryToBy(tag: Int) {
        guard let product = products?[tag].product else { return }
        print("product.price", product.price)
        StoreObserver.shared.buy(product)
    }
    
    private func openURL(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.openURL(url)
        }
        showInternetIcon()
    }
    
    //MARK: - UI Actions
    @IBAction func purchasButtonTapped(_ sender: UIButton) {
        tryToBy(tag: sender.tag)
    }
    
    @IBAction func restoreButtonTapped() {
        Loading.shared.startLoading()
        StoreObserver.shared.restore()
    }
    
    // Navigate via links
    @IBAction func privacyPolicyTapped() {
        openURL(link: ConverterLink.privacyPolicy)
    }
    
    @IBAction func termsOfUseTapped() {
        openURL(link: ConverterLink.termsOfUse)
    }
    
    //MARK: - Get Data
    private func fetchProductInformation() {
        Loading.shared.startLoading()
        StoreManager.shared.startProductRequest()
        getSubscriptionInfo()
    }
    
    private func getSubscriptionInfo() {
        if !subscribed {
            NetworkManager.shared.getSubscriptionFromServer(success: { (model) in
                Defaults.save(data: model.isPromo, key: .isPromo)
                DispatchQueue.main.async {
                    self.promoImageView.isHidden = !model.isPromo
                    Loading.shared.endLoading()
                }
            }) { (error) in
                Loading.shared.endLoading()
                debugPrint("Error -- \(error)")
            }
        }
    }
    
    //MARK: - Pop Up Style
    fileprivate func popupSetup() {
        view.backgroundColor = .popUpBackground
        subscriptionView.backgroundColor = darkMode ? .barDark : .white
        addTapGesture()
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

    private func showSubscriptionPopUp() {
        view.layoutIfNeeded()
        let width = view.frame.width
        subscriptionViewWidthConstraint.constant = isPopup ? width * 0.7 : width - 32
        guard isPopup else { return }
        DispatchQueue.main.async {
            self.showSubscriptionView()
        }
    }

    private func showSubscriptionView() {
        let destinationY = view.frame.height / 2 + subscriptionView.frame.height / 2
        subscriptionView.alpha = 0
        view.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveLinear, animations: {
//            self.subscriptionViewBottmConstraint.constant = destinationY
            self.subscriptionView.alpha = 1
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideSubscriptionView(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//            self.subscriptionViewBottmConstraint.constant = -20
            self.subscriptionView.alpha = 0
            self.view.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}

// MARK: -- StoreManagerDelegate methods implementatin
extension ManageSubscriptionViewController: StoreManagerDelegate {
    func productRequestError(_ message: String) {
        showWarningAlert(title: nil, message: message)
        showInternetIcon()
        Loading.shared.endLoading()
    }
    
    func storeManagerDidReceiveResponse(_ products: [Subscription]) {
        self.products = products
        DispatchQueue.main.async {
            self.setTitles()
            Loading.shared.endLoading()
        }
    }
}

// MARK: -- StoreObserverDelegate
extension ManageSubscriptionViewController: StoreObserverDelegate {
    func handleFailedState(with errorMessage: String) {
        DispatchQueue.main.async {
            Loading.shared.endLoading()
            self.showInternetIcon()
        }
    }
    
    func purchasedSuccess() {
        DispatchQueue.main.async {
            self.showInternetIcon()
            self.setupInterfeceDependOnSubscription()
            Loading.shared.endLoading()
        }
        //        NetworkManager.shared.addSubsriptionToServer(success: {
        //            self.getSubscriptionInfo()
        //        }) { (error) in
        //            self.getSubscriptionInfo()
        //            self.showWarningAlert(title: nil, message: error)
        //        }
    }
    
    func startPurchasing() {
        DispatchQueue.main.async {
            Loading.shared.startLoading()
        }
    }
    
    func handleRestoredStat() {
        purchasedSuccess()
    }
}

// MARK: -- Public
extension ManageSubscriptionViewController {
    public func setPopup(_ isPopup: Bool) {
        self.isPopup = isPopup
    }
}
