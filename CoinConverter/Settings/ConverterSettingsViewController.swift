//
//  ConverterSettingsViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import SDWebImage

class ConverterSettingsViewController: BaseViewController {
    
    @IBOutlet weak var settingsTableView: ConverterSettingsTableView!
    
    private var settingsData: [[SettingsData]] = SettingsData.getSettingsData()
    private var coins: [CoinModel]?
    private var fiats: [FiatModel]?
    private var coin: CoinModel?
    private var noWiFyIcon: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .phone {
            settingsTableView.animate()
        }
        showInternetIcon()
    }
    
    override func languageChanged() {
        super.languageChanged()
        title = "settings".localized()
        settingsTableView.reloadData()
    }
    
    private func setupTableView() {
        settingsTableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        settingsTableView.tableFooterView = UIView()
    }
    
    private func setupNavigation() {
//        title = "settings".localized()
        noWiFyIcon = UIBarButtonItem(image: UIImage(named: "no_wifi"), style: .done, target: self, action: nil)
    }
    
    private func showInternetIcon() {
        if Connectivity.shared.isConnectedToInternet() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = noWiFyIcon
        }
    }
    
    // MARK: -- Feedback implementation
    private func sendFeedback() {
        if let emailAlert = setupFeedbackAlert() {
            present(emailAlert, animated: true)
        } else {
            showWarningAlert(title: nil, message: Messages.feedbackEmailErrorMessage)
        }
    }
    
    private func showAppBuildNumber() {
        showToastAlert("", message: Bundle.main.buildVersionNumber)
    }
    
    private func setupFeedbackAlert() -> UIAlertController? {
        let feedbackAlert = UIAlertController(title: "Choose email", message: nil, preferredStyle: .actionSheet)
        
        if let action = openMail(with: .mail, title: "Mail") {
            feedbackAlert.addAction(action)
        }
        
        if let action = openMail(with: .gmail, title: "Gmail") {
            feedbackAlert.addAction(action)
        }
        
        if let action = openMail(with: .yahoo, title: "Yahoo") {
            feedbackAlert.addAction(action)
        }
        
        if let action = openMail(with: .outlook, title: "Outlook") {
            feedbackAlert.addAction(action)
        }
        
        if let action = openMail(with: .inbox, title: "Inbox") {
            feedbackAlert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        feedbackAlert.addAction(cancel)
        
        return feedbackAlert.actions.count > 1 ? feedbackAlert : nil
    }
    
    private func openMail(with: MailApplicationSettings, title: String) -> UIAlertAction? {
        let urlStr = getMailString(service: with)
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            let action = UIAlertAction(title: title, style: .default) { (_) in
                UIApplication.shared.openURL(url)
            }
            return action
        }
        return nil
    }
    
    private func getMailString(service: MailApplicationSettings) -> String {
        let supportMail = "coinconverter@witplex.com"
        let subject = "Feedback from Coin Converter!"
        var appVersion = "Unknown application version"
        if let info = Bundle.main.infoDictionary, let shortVersion = info["CFBundleShortVersionString"] as? String {
            appVersion = shortVersion
        }
        let systemVersion = UIDevice.current.systemVersion
        let body = "\n\n\nApp version: \(appVersion)\niOS version: \(systemVersion)\nDevice: \(UIDevice.modelName)"
        
        let message = service.rawValue + "?to=\(supportMail)&subject=\(subject)&body=\(body)"
        return message.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? message
    }
    
    // MARK: -- Share app
    private func shareApp() {
        var text = Messages.sharingText
        text = text.replacingOccurrences(of: "iosLink", with: ConverterLink.iosLink)
        text = text.replacingOccurrences(of: "androidLink", with: ConverterLink.androidLink)
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        
        if let view = activityVC.view {
            for buttonView in view.subviews {
                if let cancel = buttonView as? UIButton {
                    cancel.tintColor = .red
                    cancel.setTitleColor(.red, for: .normal)
                }
            }
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: -- Rate App
    private func rateApp() {
        openURL(link: ConverterLink.iosLink)
        AppRateManager.shared.requestReviewIfAppropriate()
    }
    
    // MARK: -- Go to web page
    private func openWebSite() {
        openURL(link: ConverterLink.webLink)
    }
    
    private func openURL(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: -- Push VC
    private func goToManageSubscription() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ManageSubscriptionViewController") as? ManageSubscriptionViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func openLanguagePage() {
        guard let vc = LanguageViewController.initializeStoryboard() else { return }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Get Data
    private func getAllData(failer: @escaping (Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var newError: String?
        var newExistedCoins: [CoinModel] = []
        var newCoins: [CoinModel] = []
        var newFiats: [FiatModel] = []
        
        // Get many coin
        dispatchGroup.enter()
        Loading.shared.startLoading()
        
        var existedCoinsIDs = ["bitcoin"]
        if let coinsIDs: [String] = Defaults.loadDefaults(key: .existedCoinsIDs) {
            existedCoinsIDs += coinsIDs
        }
        
        NetworkManager.shared.getExistedCoins(coinsIDs: existedCoinsIDs) { (existedCoins) in
            newExistedCoins = existedCoins
            existedCoins.forEach {
                UIImageView().sd_setImage(with: URL(string: $0.iconPath), placeholderImage: UIImage(named: "empty_icon"))
            }
            dispatchGroup.leave()
        } failer: { (error) in
            newError = error
            dispatchGroup.leave()
            debugPrint("Coins List downloading error---\(error)")
        }
        
        //Get Coins
        dispatchGroup.enter()
        NetworkManager.shared.getCoinList(skip: 0, short: !offlineMode) { (coins, _) in
            newCoins = coins
            coins.forEach {
                UIImageView().sd_setImage(with: URL(string: $0.iconPath), placeholderImage: UIImage(named: "empty_icon"))
            }
            dispatchGroup.leave()
        } failer: { (error) in
            dispatchGroup.leave()
            newError = error
        }
        
        //Get Fiats
        dispatchGroup.enter()
        NetworkManager.shared.getAllFiats(success: { (fiats) in
            newFiats = fiats
            fiats.forEach {
                UIImageView().sd_setImage(with: URL(string: $0.iconPath), placeholderImage: UIImage(named: "empty_icon"))
            }
            debugPrint("Fiat downloading successfully")
            dispatchGroup.leave()
        }) { (error) in
            newError = error
            dispatchGroup.leave()
            debugPrint("Fiat downloading error---\(error)")
        }
        
        dispatchGroup.notify(queue: .main) {
            Loading.shared.endLoading()
            if let error = newError {
                self.showWarningAlert(title: "", message: error)
                failer(true)
                self.offlineMode = false
            } else {
                RealmWrapper.shared.addObjectsInRealmDB(newExistedCoins)
                RealmWrapper.shared.addObjectsInRealmDB(newCoins)
                RealmWrapper.shared.addObjectsInRealmDB(newFiats)
            }
        }
    }
}

// MARK: -- TableView delegate and dataSource methods
extension ConverterSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell else { return BaseTableViewCell() }
        
        let sectionData = settingsData[indexPath.section]
        let item = sectionData[indexPath.row]
        cell.delegate = self
        cell.setupCell(with: sectionData, item: item, for: indexPath)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parameter = settingsData[indexPath.section][indexPath.row]
        
        switch parameter {
        case .feedback:
            sendFeedback()
        case .share:
            shareApp()
        case .rate:
            rateApp()
        case .subscription:
            goToManageSubscription()
        case .languages:
            openLanguagePage()
        case .website:
            openWebSite()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // cell.addShadow()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 2
        }
        return 0
    }
}

// MARK: - SettingsCellDelegate
extension ConverterSettingsViewController: SettingsCellDelegate {
    
    func cellTappedFiveTimes(indexPath: IndexPath) {
        guard settingsData[indexPath.section][indexPath.row] == .appVersion else { return }
        showAppBuildNumber()

    }

    func offlineModeTapped(with sender: BaseSwitch) {
        guard offlineMode else { return }
        
        getAllData { (failed) in
            sender.isOn = !failed
        }
    }
}
