//
//  ConverterViewController.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit
import FirebaseCrashlytics

class ConverterViewController: BaseViewController {

   @IBOutlet weak var converterTableView: BaseTableView!
   @IBOutlet var coinFiatHeaderView: CoinFiatHeaderView!
   private var adsViewForConvertor: AdsView?

   private var noWiFyIcon: UIBarButtonItem!
   private var refreshControl: UIRefreshControl?

   private var bottomContentInsets: CGFloat = 0 {
       willSet {
          converterTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: newValue, right: 0)
       }
   }

   private let viewModel = ConverterViewModel()

   // MARK: - Static
   static func initializeStoryboard() -> ConverterViewController? {
      return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ConverterViewController.name) as? ConverterViewController
   }

   // MARK: - Life Sycle
   override func viewDidLoad() {
      super.viewDidLoad()
      setup()
   }
   
   override func viewWillLayoutSubviews() {
      coinFiatHeaderView.delegate = viewModel
      coinFiatHeaderView.setupData(viewModel.reversed)
      coinFiatHeaderView.addRotateAnimation()
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      showInternetIcon()
      self.checkUserForAds()
      self.tabBarController?.tabBar.items?[1].title = ""
      if viewModel.subscriptionChanged {
         viewModel.updateSubscription()
      }
      converterTableView.reloadData()
   }

   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      adsViewForConvertor?.removeFromSuperview()
      hideKeyboard()
   }

   override func willEnterForeground() {
      super.willEnterForeground()
      viewModel.getExistedCoins()
   }

   override func languageChanged() {
      super.languageChanged()
      title = "converter".localized()
      self.tabBarController?.tabBar.items?[1].title = ""
   }
   
//   // MARK: - Keyboard
//   override func keyboardWillShow(_ sender: Notification) {
//      super.keyboardWillShow(sender)
//      view.addGestures(target: self, action: #selector(hideKeyboard))
//   }
//
//   override func keyboardWillHide(_ sender: Notification) {
//      super.keyboardWillHide(sender)
//      view.removeGestures()
//   }
   

   //MARK: - Setup
   private func setup() {
      setupNavigation()
      setupTableView()
      addRefreshControl()
      viewModel.delegate = self
      viewModel.setup()
   }

   private func setupNavigation() {
      navigationController?.isNavigationBarHidden = false
      noWiFyIcon = UIBarButtonItem(image: UIImage(named: "no_wifi"), style: .done, target: self, action: nil)
   }

   private func showInternetIcon() {
      if Connectivity.shared.isConnectedToInternet() {
         navigationItem.setRightBarButtonItems([], animated: false)
      } else {
         navigationItem.setRightBarButtonItems([noWiFyIcon], animated: false)
      }
   }

   private func setupTableView() {
      converterTableView.register(UINib(nibName: "CoinInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "coinInfoCell")
      converterTableView.register(UINib(nibName: "CoinMainTableViewCell", bundle: nil), forCellReuseIdentifier: "coinMainCell")
      converterTableView.register(UINib(nibName: "FiatMainTableViewCell", bundle: nil), forCellReuseIdentifier: "fiatMainCell")
      converterTableView.register(UINib(nibName: "CoinFiatTableViewCell", bundle: nil), forCellReuseIdentifier: "coinFiatCell")
      converterTableView.register(UINib(nibName: "AddCoinFiatTableViewCell", bundle: nil), forCellReuseIdentifier: "addCoinFiatCell")
      
      converterTableView.showsVerticalScrollIndicator = false
      converterTableView.separatorColor = .clear
   }

   private func addRefreshControl() {
      refreshControl = UIRefreshControl()
      refreshControl?.addTarget(self, action: #selector(refreshPage), for: .valueChanged)

      if #available(iOS 10.0, *) {
         converterTableView.refreshControl = refreshControl
      } else {
         converterTableView.backgroundView = refreshControl
      }
   }

   @objc public func refreshPage() {
      viewModel.getExistedCoins()
   }

}

// MARK: - CoinFiatFooterViewDelegate
extension ConverterViewController: CoinFiatFooterViewDelegate {
   func textFieldTextChanged(count: Double) {
      viewModel.convertAfterAddingCripto(count: count)
   }
}

// MARK: - AddCoinFiatTableViewCellDelegate
extension ConverterViewController: AddCoinFiatTableViewCellDelegate {
   func plusTapped(section: Int) {
      print(section)
      if viewModel.limitationCheck(section) {
         showCriptoList(section: section)
      } else {
         showSubscriptionPopup()
      }
   }

   // helper functions
   private func showCriptoList(section: Int, changeHeaderCoin: Bool = false, changeHeaderFiat: Bool = false) {
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectCoinFiatViewController") as? SelectCoinFiatViewController else { return }

      vc.delegate = viewModel
      vc.isSelectedFiat = section == 1 || changeHeaderFiat == true
      vc.openedForChangeHeaderCoin = changeHeaderCoin
      vc.openedForChangeHeaderFiat = changeHeaderFiat
      
      vc.currentHeaderCoin = viewModel.headerCoin
      vc.currentHeaderFiat = viewModel.headerFiat
      vc.allFiats = viewModel.allFiats
      vc.addedCoinIDs = viewModel.addedCoinIDs
      vc.addedFiatCurrencys = viewModel.addedFiatCurrencys

      navigationController?.pushViewController(vc, animated: true)
   }

}

// MARK: -- TableView delegate methods
extension ConverterViewController: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 3
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print("numberOfRowsInSection \(section)", viewModel.getNumberOfRowsInSection(section))
      return viewModel.getNumberOfRowsInSection(section)
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      print("addedFiats.count", viewModel.addedFiats.count)
      if indexPath.section == 0 {
         if viewModel.reversed {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fiatMainCell", for: indexPath) as? FiatMainTableViewCell {
               if let fiat = viewModel.headerFiat {
                  cell.setupMainFiat(fiat)
               }
               cell.roundCorners()
               return cell
            }
         } else {
            if indexPath.row == 0 {
               if let cell = tableView.dequeueReusableCell(withIdentifier: "coinMainCell", for: indexPath) as? CoinMainTableViewCell {

                  if let coin = viewModel.headerCoin {
                     cell.setupMainCoin(coin)
                  }

                  return cell
               }
            } else {
               if let cell = tableView.dequeueReusableCell(withIdentifier: "coinInfoCell", for: indexPath) as? CoinInfoTableViewCell {

                  if let coinData = viewModel.infoCoinData {
                     cell.setupCoinInfo(with: coinData, for: indexPath)
                  }
                  return cell
               }
            }
         }
      } else if indexPath.section == 1 {
         if indexPath.row == viewModel.addedFiats.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "addCoinFiatCell") as? AddCoinFiatTableViewCell {
               cell.delegate = self
               cell.setup(for: indexPath)
               return cell
            }
         } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "coinFiatCell") as? CoinFiatTableViewCell {
               cell.setupFiat(with: viewModel.addedFiats, for: indexPath)
               return cell
            }
         }
      } else if indexPath.section == 2 {
         if indexPath.row == viewModel.addedCoins.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "addCoinFiatCell") as? AddCoinFiatTableViewCell {
               cell.delegate = self
               cell.setup(for: indexPath)
               return cell
            }
         } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "coinFiatCell") as? CoinFiatTableViewCell {
               cell.setupCoin(with: viewModel.addedCoins, for: indexPath)
               return cell
            }
         }
      }

      return BaseTableViewCell()
   }

   // MARK: -- Table View action part
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard [0, 2].contains(indexPath.section) else { return }

      let isSelectHeaderCoin = (tableView.cellForRow(at: indexPath) as? CoinInfoTableViewCell) != nil
      let isSelectCoin = (tableView.cellForRow(at: indexPath) as? CoinFiatTableViewCell) != nil
      let isSelectPlus = (tableView.cellForRow(at: indexPath) as? AddCoinFiatTableViewCell) != nil
      
      if isSelectHeaderCoin || isSelectCoin {
         guard let vc = storyboard?.instantiateViewController(withIdentifier: "CoinChartViewController") as? CoinChartViewController else { return }

         let coin = isSelectHeaderCoin ? viewModel.headerCoin : viewModel.addedCoins[indexPath.row]
         vc.setCoin(with: coin)
         navigationController?.pushViewController(vc, animated: true)
      } else if !isSelectPlus {
         showCriptoList(section: indexPath.section, changeHeaderCoin: !viewModel.reversed, changeHeaderFiat: viewModel.reversed)
      }
   }

   //MARK: -- Cell swipe method for less than iOS 11
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      if indexPath.section != 0 {
         if let _ = tableView.cellForRow(at: indexPath) as? CoinFiatTableViewCell {
            let remove = UITableViewRowAction(style: .destructive, title: "") { [weak self] (_, indexPath) in
               guard let self = self else { return }
               self.viewModel.deleteCripto(indexPath: indexPath)
               DispatchQueue.main.async {
                  self.converterTableView.deleteRows(at: [indexPath], with: .fade)
               }
            }
            remove.backgroundColor = .red

            if !viewModel.controlCriptoExisting(for: indexPath) {
               return []
            }
            return [remove]
         }
      }
      return []
   }

   //MARK: --  Cell swipe method for greather than iOS 11
   @available(iOS 11.0, *)
   func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      if indexPath.section != 0 {
         if let _ = tableView.cellForRow(at: indexPath) as? CoinFiatTableViewCell {
            let remove = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completion) in
               guard let self = self else { return }
               self.viewModel.deleteCripto(indexPath: indexPath)
               DispatchQueue.main.async {
                  self.converterTableView.deleteRows(at: [indexPath], with: .fade)
               }
               completion(true)
            }
            remove.image = UIImage(named: "cell_delete")
            remove.backgroundColor = darkMode ? .backgroundDark : .backgroundLight

            if !viewModel.controlCriptoExisting(for: indexPath) {
               return UISwipeActionsConfiguration(actions: [])
            }

            let swipeAction = UISwipeActionsConfiguration(actions: [remove])
            swipeAction.performsFirstActionWithFullSwipe = true
            return swipeAction
         }
      }
      return UISwipeActionsConfiguration(actions: [])
   }
   
   // MARK: -- First section footer view
   func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      if section == 0 {
         let footer = CoinFiatFooterView(frame: .zero)
         footer.delegate = self
         if viewModel.reversed {
            if let fiat = viewModel.headerFiat {
               footer.setup(symbol: fiat.currency)
            }
         } else {
            if let coin = viewModel.headerCoin {
               footer.setup(symbol: coin.symbol)
            }
         }
         return footer
      }
      return nil
   }

   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      if section == 0 {
         return CoinFiatFooterView.height
      }
      return 0
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 0 {
         if viewModel.reversed {
            return FiatMainTableViewCell.height
         } else {
            if indexPath.row == 0 {
               return CoinMainTableViewCell.height
            } else {
               return CoinInfoTableViewCell.height
            }
         }
      } else {
         if let _ = tableView.cellForRow(at: indexPath) as? AddCoinFiatTableViewCell {
            return AddCoinFiatTableViewCell.height
         } else {
            return CoinFiatTableViewCell.height
         }
      }
   }

   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      hideKeyboard()
   }

}

// MARK: - View Model Delegate
extension ConverterViewController: ConverterViewModelDelegate {
   func reloadData() {
      DispatchQueue.main.async {
         self.converterTableView.reloadData()
         self.refreshControl?.endRefreshing()
         self.converterTableView.isHidden = false
         self.coinFiatHeaderView.setupData(self.viewModel.reversed)
      }
   }

   func requestFailed(with error: String) {
      DispatchQueue.main.async {
         self.endLoading()
         self.refreshControl?.endRefreshing()
         self.showToastAlert("", message: error)
      }
   }

   func startLoading() {
      Loading.shared.startLoading()
   }

   func endLoading() {
      Loading.shared.endLoading()
   }

}

// MARK: - Ads Methods -
extension ConverterViewController {
   func checkUserForAds() {
      AdsManager.shared.checkUserForAds(zoneName: .converter) { [weak self] adsView in
         guard let self = self else { return }
         DispatchQueue.main.async {
            self.adsViewForConvertor = adsView
            self.setupAds()
         }
      }
   }

   func setupAds() {
      guard let adsViewForAccount = adsViewForConvertor else { return }

      self.view.addSubview(adsViewForAccount)
      adsViewForAccount.translatesAutoresizingMaskIntoConstraints = false
      adsViewForAccount.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
      view.rightAnchor.constraint(equalTo: adsViewForAccount.rightAnchor, constant: 10).isActive = true
      if #available(iOS 11.0, *) {
         view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: adsViewForAccount.bottomAnchor, constant: 48).isActive = true
      } else {
         view.bottomAnchor.constraint(equalTo: adsViewForAccount.bottomAnchor, constant: 100).isActive = true
      }
      bottomContentInsets = 200
   }
}
