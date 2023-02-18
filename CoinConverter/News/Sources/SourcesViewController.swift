//
//  SourcesViewController.swift
//  MinerBox
//
//  Created by Vazgen Hovakimyan on 07.12.21.
//  Copyright © 2021 WitPlex. All rights reserved.
//

import UIKit

class SourcesViewController: BaseViewController {
    
    //MARK: - Views -
    @IBOutlet weak var sourceSearchBar: BaseSearchBar!
    private var searchButton: UIBarButtonItem!
    @IBOutlet weak var searchBarHeigthConstraits: NSLayoutConstraint!
    @IBOutlet weak var sourceCollectionView: BaseCollectionView!
    
    private var addedSources = [String]()
    private var allSources = [String]()
    private var filtredAddSeources = [String]()
    private var filtredAllSources = [String]()
    public var isFromEmptyNews = true
    
    // MARK: - Static
    static func initializeStoryboard() -> SourcesViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SourcesViewController.name) as? SourcesViewController
    }
    
    //MARK: - Live Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionLayout()
        self.getSources()
        self.setupNavigation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NewsCacher.shared.updateMyFeed = true
        UserDefaults.standard.setValue(addedSources.isEmpty, forKey: "added_sources_enpty")
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.shadowImage = UIImage()
        sourceSearchBar.delegate = self
        
        searchButton = UIBarButtonItem.customButton(self, action: #selector(_showSearchBar), imageName: "search")
        searchButton.isEnabled = false
        let buttons: [UIBarButtonItem] = [searchButton]
        navigationItem.setRightBarButtonItems(buttons, animated: false)
    }
    override func languageChanged() {
        title =  "sources".localized()
    }
    
    
    //MARK: - Action -
    func getSources() {
        Loading.shared.startLoading()
        
        NewsManager.shared.getSources { sources in
            
            self.addedSources = sources.added
            self.allSources = sources.all
            self.filtredAddSeources = sources.added
            self.filtredAllSources = sources.all
            self.searchButton.isEnabled = true
            self.sourceCollectionView.reloadData()
            Loading.shared.endLoading()
            
        } failer: { err in
            print(err)
            Loading.shared.endLoading()
        }
    }
    func addSource(source: String, success: @escaping() -> Void){
        Loading.shared.startLoading()
        NewsManager.shared.addSource(source: source) {
            success()
            Loading.shared.endLoading()
        } failer: { err in
            print(err)
            Loading.shared.endLoading()
        }
        
    }
    func removeSource(source: String,success: @escaping() -> Void ){
        Loading.shared.startLoading()
        NewsManager.shared.removeSource(source: source) {
            success()
            Loading.shared.endLoading()
        } failer: { err in
            print(err)
            Loading.shared.endLoading()
        }
    }
    func configCollectionLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 106, height: 130)
        flowLayout.sectionInset = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        self.sourceCollectionView.collectionViewLayout = flowLayout
        self.sourceCollectionView.backgroundColor = .clear
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: SourceCollectionViewCell.name, bundle: nil)
        self.sourceCollectionView.register(cellNib, forCellWithReuseIdentifier: SourceCollectionViewCell.name)
    }
    
    @objc func goToNewViewController() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.addedNewSources), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            guard let navigation = self.navigationController else { return }
            for controller in navigation.viewControllers {
                if let newsVC = controller as? NewsPageController {
                    navigation.popToViewController(newsVC, animated: true)
                    return
                }
            }
        })
    }
}

//MARK: - UICollectionViewDelegate  -

extension SourcesViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ?  filtredAddSeources.count : filtredAllSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = sourceCollectionView.dequeueReusableCell(withReuseIdentifier: SourceCollectionViewCell.name, for: indexPath) as? SourceCollectionViewCell  {
            cell.delegate = self
            if  indexPath.section == 0 {
                cell.setData(sourceName: filtredAddSeources[indexPath.row ], indexPath: indexPath, isAdded: true)
            } else {
                cell.setData(sourceName: filtredAllSources[indexPath.row ], indexPath: indexPath, isAdded: false)
            }
            return cell
        }
        return SourceCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14.0
    }
}


extension SourcesViewController: SourceCollectionViewCellDelegate {
    
    func minusAction(indexPath: IndexPath) {
        
        let source = addedSources[indexPath.row]
        self.sourceCollectionView.isUserInteractionEnabled = false
        
        self.removeSource(source: source) {
            
            guard !self.isFromEmptyNews else {
                self.goToNewViewController()
                return
            }
            
            self.addedSources.remove(at: indexPath.row )
            self.filtredAddSeources.remove(at: indexPath.row)
            self.allSources.append(source)
            self.filtredAllSources.append(source)
            self.sourceCollectionView.reloadData()
            self.sourceCollectionView.isUserInteractionEnabled = true
        }
    }
    
    func plusAction(indexPath: IndexPath) {
        let source = allSources[indexPath.row]
        
        self.sourceCollectionView.isUserInteractionEnabled = false
        self.addSource(source: source) {
         
            self.allSources.remove(at: indexPath.row)
            self.filtredAllSources.remove(at: indexPath.row)
            self.addedSources.append(source)
            self.filtredAddSeources.append(source)
            self.sourceCollectionView.reloadData()
            self.sourceCollectionView.isUserInteractionEnabled = true
            
            guard !self.isFromEmptyNews else {
                self.goToNewViewController()
                return
            }
        }
    }
}

// MARK: - Search delegate
extension SourcesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        
        guard searchText != "" else {
            filtredAddSeources =  addedSources
            filtredAllSources  =  allSources
            sourceCollectionView.reloadData()
            return
        }
        
        filtredAddSeources =  addedSources.filter({$0.lowercased().contains(searchText)})
        filtredAllSources  =  allSources.filter({$0.lowercased().contains(searchText)})
        sourceCollectionView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filtredAddSeources =  addedSources
        filtredAllSources  =  allSources
        sourceCollectionView.reloadData()
        hideSearchBar()
    }
    
    //search
    private func hideSearchBar() {
        if !sourceSearchBar.isHidden {
            sourceSearchBar.text = ""
            view.endEditing(true)
            let buttons: [UIBarButtonItem] = [searchButton]
            navigationItem.setRightBarButtonItems(buttons, animated: false)
            
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.searchBarHeigthConstraits.constant = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.sourceSearchBar.isHidden = true
            }
        }
    }
    
    @objc private func _showSearchBar() {
        if sourceSearchBar.isHidden {
            sourceSearchBar.isHidden = false
            let buttons: [UIBarButtonItem] = []
            navigationItem.setRightBarButtonItems(buttons, animated: true)
            UIView.animate(withDuration: Constants.animationDuration) {
                self.searchBarHeigthConstraits.constant = 40
                self.sourceSearchBar.becomeFirstResponder()
                self.view.layoutIfNeeded()
            }
        }
    }
}
