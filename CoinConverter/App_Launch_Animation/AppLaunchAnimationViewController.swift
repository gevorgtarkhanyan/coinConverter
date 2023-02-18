//
//  AppLaunchAnimationViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/25/19.
//

import UIKit
import StoreKit

class AppLaunchAnimationViewController: BaseViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var appNameParentView: GradientView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var loadingButton: SpinnerButton!
    @IBOutlet weak var retryButton: BaseButton!
    
    private var coins: [CoinModel]?
    private var fiats: [FiatModel]?
    private var existedCoins: [CoinModel]?
    private var mainCoin: CoinModel?
    private var mainFiat: FiatModel?
    private var errorTitle = "Unable to download data"
    private var error: String?
    
    @IBOutlet weak var icon1ImageView: BaseImageView!
    @IBOutlet weak var icon2ImageView: BaseImageView!
    @IBOutlet weak var icon3ImageView: BaseImageView!
    @IBOutlet weak var icon4ImageView: BaseImageView!
    
    // MARK: - Static
    static func initializeStoryboard() -> AppLaunchAnimationViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AppLaunchAnimationViewController.name) as? AppLaunchAnimationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        UIApplication.appDelegate.rotationEnabled = false
        initialSetup()
        iconScaleAnimation()
        setupNavigation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateSpinner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.appDelegate.rotationEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = darkMode ? .backgroundDark : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func initialSetup() {
        appNameParentView.mask = appNameLabel
        loadingButton.showAsCircle()
    }
    
    private func animateSpinner() {
        loadingButton.startAnimation()
    }
    
    private func iconScaleAnimation() {

        icon1ImageView.image = UIImage(named: darkMode ? "app1_icon" :"app1_lightMode")
        icon2ImageView.image = UIImage(named: darkMode ? "app2_icon" :"app2_lightMode")
        icon3ImageView.image = UIImage(named: darkMode ? "app3_icon" :"app3_lightMode")
        icon4ImageView.image = UIImage(named: darkMode ? "app4_icon" :"app4_lightMode")
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0) {
                self.icon1ImageView.frame.origin.x = self.iconImageView.frame.origin.x
                self.icon1ImageView.frame.origin.y = self.iconImageView.frame.origin.y
                
                self.icon2ImageView.frame.origin.x = self.iconImageView.frame.center.x + 4
                self.icon2ImageView.frame.origin.y = self.iconImageView.frame.origin.y
                
                self.icon3ImageView.frame.origin.x = self.iconImageView.frame.origin.x
                self.icon3ImageView.frame.origin.y = self.iconImageView.frame.center.y + 4
                
                self.icon4ImageView.frame.origin.x = self.iconImageView.frame.center.x + 4
                self.icon4ImageView.frame.origin.y = self.iconImageView.frame.center.y + 4
            } completion: { _ in
                self.sendDeviceInfo()
            }
        }
    }
    @IBAction func skipButtonTapped() {
        loadingButton.isHidden = false
        animateSpinner()
        sendDeviceInfo()
    }
    
    private func setupSkipButton() {
        retryButton.setLocalizedTitle("retry")
        retryButton.isHidden = false
        retryButton.isUserInteractionEnabled = true
        loadingButton.stopAnimation(with: false)
        loadingButton.isHidden = true
    }
    
    private func sendDeviceInfo() {
        retryButton.isUserInteractionEnabled = false
        NetworkManager.shared.sendDeviceInfo {
            self.downloadCriptoData()
        }
    }
    
    private func downloadCriptoData() {
        var subscriptuionRequestSuccses = false
        var zoneIdsRequestSuccses = false
        
        let dispatchGroup = DispatchGroup()
        
        // Get Subscription
        dispatchGroup.enter()
        NetworkManager.shared.getSubscriptionFromServer(success: { (model) in
            Defaults.save(data: model.isPromo, key: .isPromo)
            subscriptuionRequestSuccses = true
            dispatchGroup.leave()
        }) { (error) in
            self.error = error
            dispatchGroup.leave()
            debugPrint("Error -- \(error)")
        }
        
        //Get Zone Ids
        dispatchGroup.enter()
        AdsRequestService.shared.getZoneIdsList {
            zoneIdsRequestSuccses = true
            dispatchGroup.leave()
        } failer: { [weak self] error in
            guard let self = self else { return }
            self.error = error
            dispatchGroup.leave()
            debugPrint("Error -- \(error)")
        }
        
        dispatchGroup.notify(queue: .main) {

            if self.offlineMode || (subscriptuionRequestSuccses && zoneIdsRequestSuccses) {
                self.goToConverterPage()
            } else {
                if let errorMessage = self.error {
                    self.showWarningAlert(title: self.errorTitle, message: errorMessage) { ok in
                        print("")
                    }
                    self.error = nil
                }
                self.setupSkipButton()
            }
        }
    }
    
    private func goToConverterPage() {
        loadingButton.stopAnimation {

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BaseTabBarController")

            appDelegate.window?.rootViewController = controller
        }
    }
 
    private func getMainFiat() -> FiatModel? {
        if let fiats = fiats {
            mainFiat = fiats[0]
        }
        return mainFiat
    }
    
    private func getMainCoin() -> CoinModel? {
        if let coins = coins {
            mainCoin = coins[0]
        }
        return mainCoin
    }
    
    // MARK: -- Update Locally saved cripto data
    private func update(savedCoin: CoinModel, in coins: [CoinModel]) -> CoinModel {
        for coin in coins {
            if coin.coinId == savedCoin.coinId {
                return coin
            }
        }
        return savedCoin
    }
    
    private func update(savedFiat: FiatModel, in fiats: [FiatModel]) -> FiatModel {
        for fiat in fiats {
            if fiat.currency == savedFiat.currency {
                return fiat
            }
        }
        return savedFiat
    }
    
    private func update(savedCoins: [CoinModel], in coins: [CoinModel]) -> [CoinModel] {
        var addedCoins: [CoinModel] = []
        
        for savedCoin in savedCoins {
            for coin in coins {
                if savedCoin.coinId == coin.coinId {
                    addedCoins.append(coin)
                    break
                }
            }
        }
        return addedCoins
    }
    
    private func update(savedFiats: [FiatModel], in fiats: [FiatModel]) -> [FiatModel] {
        var addedFiats: [FiatModel] = []
        
        for savedFiat in savedFiats {
            for fiat in fiats {
                if savedFiat.currency == fiat.currency {
                    addedFiats.append(fiat)
                    break
                }
            }
        }
        
        return addedFiats
    }
}
