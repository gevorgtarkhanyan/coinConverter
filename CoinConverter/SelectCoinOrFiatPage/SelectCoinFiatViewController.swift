//
//  SelectCoinFiatViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import StoreKit

protocol SelectCoinFiatViewControllerDelegate: AnyObject {
    func getHeaderFiat(_ fiat: FiatModel)
    func getFiat(_ fiat: FiatModel)
    func getHeaderCoin(_ fiat: CoinModel)
    func getCoin(_ coin: CoinModel)
}

class SelectCoinFiatViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: BaseSearchBar!
    @IBOutlet weak var selectCoinFiatTableView: BaseTableView!
    @IBOutlet weak var scrollTopImageView: UIImageView!
    private var noWiFyIcon: UIBarButtonItem!
    
    weak var delegate: SelectCoinFiatViewControllerDelegate?
    
    public var isSelectedFiat = false
    private var timer = Timer()
    private var isPaginating = false
    private var searchText: String?
    
    private var filteredCoins: [CoinModel] = []
    private var filteredFiats: [FiatModel] = []
    
    public var allFiats: [FiatModel] = []
    private var allCoins: [CoinModel] {
        set {
            Cacher.shared.allCoins = newValue
        }
        get {
            return Cacher.shared.allCoins
        }
    }
    
    private var skip: Int {
        return allCoins.count
    }
    
    public var openedForChangeHeaderCoin = false
    public var openedForChangeHeaderFiat = false
    public var currentHeaderCoin: CoinModel?
    public var currentHeaderFiat: FiatModel?
    public var addedCoinIDs = [String]()
    public var addedFiatCurrencys = [String]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            selectCoinFiatTableView.animate()
        }
        
        showInternetIcon()
    }

    private func initialSetup() {
        filteredCoins = allCoins
        filteredFiats = allFiats
        isPaginating = false
        if !isSelectedFiat && allCoins.isEmpty {
            getCoinList()
        }
    }
    
    private func setupTableView() {
        selectCoinFiatTableView.register(UINib(nibName: "SelectCoinFiatCell", bundle: nil), forCellReuseIdentifier: "selectedCripto")
        setupScrollImageView()
    }
    
    //must be modified
    func setupScrollImageView() {
        let tapDesture = UITapGestureRecognizer(target: self, action: #selector(scrollTop))
        scrollTopImageView.isHidden = true
        scrollTopImageView.isUserInteractionEnabled = true
        scrollTopImageView.addGestureRecognizer(tapDesture)
        scrollTopImageView.layer.cornerRadius = scrollTopImageView.frame.size.height / 2
        scrollTopImageView.image = UIImage(named: "arrow_up")?.withRenderingMode(.alwaysTemplate)
        
        scrollTopImageView.tintColor = darkMode ? .white : .black
        scrollTopImageView.backgroundColor = darkMode ? UIColor.viewDarkBackgroundWithAlpha : UIColor.viewLightBackgroundWithAlpha
    }
    
    private func setupNavigation() {
        title = isSelectedFiat ? "Fiat" : "Coin"
    }
    
    private func showInternetIcon() {
        if Connectivity.shared.isConnectedToInternet() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = noWiFyIcon
        }
    }

    @objc private func scrollTop() {
        self.selectCoinFiatTableView.scroll(to: .top, animated: true)
    }
    
}

//MARK: - Get Data
extension SelectCoinFiatViewController {
    private func getCoinList(with skip: Int = 0) {
        Loading.shared.startLoading()
        NetworkManager.shared.getCoinList(skip: 0, short: !offlineMode) { (coins, _) in
            self.allCoins = coins
            self.filteredCoins = coins
            if self.offlineMode {
                RealmWrapper.shared.addObjectsInRealmDB(self.allCoins)
            }
            DispatchQueue.main.async {
                Loading.shared.endLoading()
                self.selectCoinFiatTableView.reloadData()
            }
        } failer: { (error) in
            DispatchQueue.main.async {
                Loading.shared.endLoading()
                if self.offlineMode {
                    self.getLocalCoins()
                } else {
                    self.showWarningAlert(title: "", message: error)
                }
            }
        }
    }
    
    private func getSearchCoins(with searchText: String) {
        Loading.shared.startLoading()
        NetworkManager.shared.getCoinList(skip: 0, short: false, searchText: searchText) { (searchCoins, allCount) in
            Loading.shared.endLoading()
            if self.searchText != nil {
                self.filteredCoins = searchCoins
                self.isPaginating = self.filteredCoins.count == allCount
                DispatchQueue.main.async {
                    self.selectCoinFiatTableView.reloadDataScrollUp()
                }
            }
        } failer: { (error) in
            Loading.shared.endLoading()
            if self.searchText != nil {
                self.showWarningAlert(title: "", message: error)
            }
        }
    }
    
    func getLocalCoins() {
        allCoins = RealmWrapper.shared.getAllObjectsOfModel(CoinModel.self) ?? []
        filteredCoins = allCoins
        selectCoinFiatTableView.reloadData()
    }
}

//MARK: - SearchBar delegate methods
extension SelectCoinFiatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isSelectedFiat {
            filteredFiats = allFiats.filter({$0.currency.lowercased().contains(searchText.lowercased())})
            if searchText.isEmpty {
                filteredFiats = allFiats
            }
        } else {
            if searchText.isEmpty {
                filteredCoins = allCoins
            } else if offlineMode && !Connectivity.shared.isConnectedToInternet() {
                filteredCoins = allCoins.filter({($0.name + $0.symbol).lowercased().contains(searchText.lowercased())})
            } else {
                self.searchText = searchText
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.searching), userInfo: nil, repeats: true)
            }
        }
        selectCoinFiatTableView.reloadData()
    }
    
    @objc private func searching() {
        timer.invalidate()
        if let searchText = searchText {
            getSearchCoins(with: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchText = nil
        initialSetup()
        hideKeyboard()
        selectCoinFiatTableView.reloadData()
    }
}

// MARK: -- TableView Delegate DataSource
extension SelectCoinFiatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSelectedFiat ? filteredFiats.count : filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCripto", for: indexPath) as? SelectCoinFiatCell {
            if isSelectedFiat {
                cell.setup(with: filteredFiats, indexPath: indexPath)
            } else {
                cell.setup(with: filteredCoins, indexPath: indexPath)
            }
            return cell
        }
        return BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if openedForChangeHeaderCoin {
            let selectedCoin = filteredCoins[indexPath.row]
            if currentHeaderCoin?.coinId == selectedCoin.coinId {
                showToastAlert(nil, message: "item_already_exist".localized())
            } else {
                delegate?.getHeaderCoin(selectedCoin)
                navigationController?.popViewController(animated: true)
            }
        } else if openedForChangeHeaderFiat {
            let selectedFiat = filteredFiats[indexPath.row]
            if currentHeaderFiat?.currency == selectedFiat.currency {
                showToastAlert(nil, message: "item_already_exist".localized())
            } else {
                delegate?.getHeaderFiat(selectedFiat)
                navigationController?.popViewController(animated: true)
            }
        } else if isSelectedFiat {
            let selectedFiat = filteredFiats[indexPath.row]
            if addedFiatCurrencys.contains(where: { $0 == selectedFiat.currency }) {
                showToastAlert(nil, message: "item_already_exist".localized())
            } else {
                delegate?.getFiat(selectedFiat)
                navigationController?.popViewController(animated: true)
            }
        } else {
            let selectedCoin = filteredCoins[indexPath.row]
            if addedCoinIDs.contains(where: { $0 == selectedCoin.coinId }) {
                showToastAlert(nil, message: "item_already_exist".localized())
            } else {
                delegate?.getCoin(selectedCoin)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

//MARK: - Pagination
extension SelectCoinFiatViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // hiding keyboard during scrolling
        hideKeyboard()
        
        let position = scrollView.contentOffset.y
        scrollTopImageView.isHidden = position < 100
        if position > selectCoinFiatTableView.contentSize.height - scrollView.frame.size.height * 0.85 {
            if !isPaginating && !isSelectedFiat {
                selectCoinFiatTableView.tableFooterView = createIndicatorFooter()
                self.isPaginating = true
                NetworkManager.shared.getCoinList(skip: skip, short: !self.offlineMode, searchText: searchText, success: { (coins, allCount)  in
                    if self.searchText == nil {
                        self.allCoins += coins
                        self.filteredCoins = self.allCoins
                        if self.offlineMode {
                            RealmWrapper.shared.addObjectsInRealmDB(coins)
                        }
                    } else {
                        self.filteredCoins += coins
                    }
                    DispatchQueue.main.async {
                        self.selectCoinFiatTableView.tableFooterView = nil
                        self.selectCoinFiatTableView.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isPaginating = self.filteredCoins.count == allCount
                    }
                }) { (error) in
                    self.showWarningAlert(title: "", message: error)
                    self.selectCoinFiatTableView.tableFooterView = nil
                    self.isPaginating = false
                }
            }
        }
    }
    
    private func createIndicatorFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        Loading.shared.startLoadingForView(with: footerView)
        return footerView
    }
}
