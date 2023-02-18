//
//  NewsContentViewController.swift
//  CoinConverter
//
//  Created by Vazgen Hovakimyan on 22.12.21.
//  Copyright © 2021 WitPlex. All rights reserved.
//

import UIKit

protocol NewsContentViewControllerDelegate: AnyObject {
    func liked (row: Int)
    func bookmarkTapped(row: Int)
    func wathed(row: Int)
}

class NewsContentViewController: BaseViewController {
    
    //MARK: - Views -
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentTextView: BaseTextView!
    @IBOutlet weak var contentBackgorundView: BaseView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: BaseLabel!
    @IBOutlet weak var viewsIconImageView: BaseImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var viewsWidthConstraits: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsIconView: BaseImageView!
    @IBOutlet weak var likeButton: NewsButton!
    @IBOutlet weak var likeLabel: NewsLabel!
    @IBOutlet weak var bookmarkButton: NewsButton!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var creatorLabel: BaseLabel!
    @IBOutlet weak var headerViewHeightConstraits: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraits: NSLayoutConstraint!
    @IBOutlet weak var bookmarkAndLikeConstraits: NSLayoutConstraint!
    private var resizeButton: UIBarButtonItem!
    private var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var categoresCollectionView: BaseCollectionView!
    @IBOutlet weak var categoriesHeightContraits: NSLayoutConstraint!
    private var countLineCategoresView = 0
    private var collectionTextSize: CGFloat = 12
    
    public var localNews: NewsModel?
    public var indexNews: Int?
    weak var delegate: NewsContentViewControllerDelegate?
    
    private var adsViewForDetailNews: AdsView?
    private var contetTextSize: ContentNewsSize = .firstFont
    
    private var news: NewsModel?
    
    var bottomContentInsets: CGFloat = 0 {
        willSet {
            scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: newValue, right: 0)
        }
    }
    
    // MARK: - Static
    static func initializeStoryboard() -> NewsContentViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NewsContentViewController.name) as? NewsContentViewController
    }
    
    //MARK: - Live Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.setupViews()
        self.getNewsDetail()
        self.setupNavigation()
    }
    
    override func languageChanged() {
        title = "news".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkUserForAds()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adsViewForDetailNews?.removeFromSuperview()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateCategoriesCollectionView()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(likeChanged), name: .likeStatusChanged, object: nil)
    }
    
    func setupViews() {
        self.newsIconView.image = UIImage(named: "coin_alert")
        self.viewsLabel.textColor = .lightGray
        self.dateLabel.textColor = .lightGray
        self.viewsIconImageView.image = UIImage(named: "views_Icon")
        self.urlButton.tintColor = .endGradient
        
        self.bookmarkButton.setImage( localNews!.isBookmarked ? UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "unselected_bookmark")?.withRenderingMode(.alwaysTemplate)  , for: .normal )
        self.likeButton.setImage(localNews?.userAction == 1  ? UIImage(named: "like_icon")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "unlike_icon")?.withRenderingMode(.alwaysTemplate)  , for: .normal )
        
        if let contetTextSize = UserDefaults.standard.value(forKey: "contet_text_size") as? String  {
            switch contetTextSize {
            case ContentNewsSize.firstFont.rawValue:
                self.contetTextSize = .firstFont
            case ContentNewsSize.secondFont.rawValue:
                self.contetTextSize = .secondFont
            case ContentNewsSize.thirdFont.rawValue:
                self.contetTextSize = .thirdFont
            default:
                print("no UserData")
            }
            self.resizeTextFont()
        }
        self.configCollectionLayout()
    }
    
    func configCollectionLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.estimatedItemSize = CGSize(width: 50, height: 50)
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.categoresCollectionView.collectionViewLayout = flowLayout
        self.categoresCollectionView.roundCorners(radius: 10)
        self.categoresCollectionView.dataSource = self
        self.categoresCollectionView.delegate = self
        self.categoresCollectionView.sizeToFit()
        self.categoresCollectionView.backgroundColor = .clear
        self.contentTextView.backgroundColor = .clear
        self.contentBackgorundView.backgroundColor = .clear
    }
    
    func updateViews() {
        self.titleLabel.text = news?.title
        if (news!.date.getDateRangeInCurrentDate().contains("sec".localized())) || news!.date.getDateRangeInCurrentDate().contains("min".localized()) || news!.date.getDateRangeInCurrentDate().contains("hr".localized()){
            self.dateLabel.text =   news!.date.getDateRangeInCurrentDate() + " " + "ago".localized()
        } else {
            self.dateLabel.text =  news?.date.getDateFromUnixTime()
        }
        self.urlButton.setTitle(news?.source, for: .normal)
        self.contentTextView.attributedText = news?.content.htmlAttributed(using: Font.regularFont.withSize(11))
        if let contetTextSize = UserDefaults.standard.value(forKey: "contet_text_size") as? String  {
            switch contetTextSize {
            case ContentNewsSize.firstFont.rawValue:
                self.contentTextView.font = UIFont(name: "Helvetica", size: 11 * 3)
            case ContentNewsSize.secondFont.rawValue:
                self.contentTextView.font = UIFont(name: "Helvetica", size: 11 * 2)
            case ContentNewsSize.thirdFont.rawValue:
                self.contentTextView.font = UIFont(name: "Helvetica", size: 11 * 1)
            default:
                break
            }
        }
        self.contentTextView.textColor = darkMode ? .white : .black
        self.contentTextView.tintColor = .endGradient
        self.newsIconView.sd_setImage(with: URL(string: news!.image), placeholderImage: UIImage(named: "new_placeholder"), completed: nil)
        self.urlButton.addTarget(self, action: #selector(openNewURL), for: .touchUpInside)
        self.likeButton.addTarget(self, action: #selector(liked), for: .touchUpInside)
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        self.creatorLabel.setLocalizableText(news?.creator ?? "")
        if localNews!.liked != 0 { self.likeLabel.text =  localNews?.liked.getString()}
        self.viewsLabel.text = (localNews!.watched + 1).getString()
        
    }
    
    func updateCategoriesCollectionView() {
        self.view.layoutIfNeeded()
        self.categoresCollectionView.reloadData()
        self.categoresCollectionView.layoutIfNeeded()
        self.contentTextView.adjustUITextViewHeight()
        self.contentViewHeight.constant = self.contentTextView.frame.height
        let height = self.categoresCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.categoriesHeightContraits.constant = height
        if height == 10 { bottomContentInsets = adsViewForDetailNews == nil ? 20 : 200 }
    }
    
    func setupNavigation() {
        
        resizeButton = UIBarButtonItem.customButton(self, action: #selector(resizeTextFont), imageName: "resize_icon")
        shareButton = UIBarButtonItem.customButton(self, action: #selector(shareNewsScreen), imageName: "share_icon")
        
        resizeButton.isEnabled = false
        shareButton.isEnabled = false
        
        let buttons: [UIBarButtonItem] = [shareButton, resizeButton ]
        navigationItem.setRightBarButtonItems(buttons, animated: false)
    }
}

//MARK: - Action -

extension NewsContentViewController {
    
    func getNewsDetail() {
        Loading.shared.startLoading()
        NewsManager.shared.getNewsDetail(newsId: localNews!.newsId) { news in
            self.news = news
            self.updateCategoriesCollectionView()
            self.updateViews()
            self.categoresCollectionView.isHidden = news.categories.count == 0
            self.scrollView.isHidden = false
            self.patchNewsViews(_id: self.localNews!._id)
            self.resizeButton.isEnabled = true
            self.shareButton.isEnabled = true
            Loading.shared.endLoading()
        } failer: { err in
            Loading.shared.endLoading()
            print(err)
        }
    }
    
    func patchNewsViews(_id: String) {
        NewsManager.shared.patchNewsViews(_id: _id) {
            print("News Watched")
            self.watched()
        } failer: { err in
            print(err)
        }
    }
    
    @objc func openNewURL() {
        openUrl(url: URL(string: news!.link)!)
    }
    
    @objc func likeChanged() {
        self.likeButton.isUserInteractionEnabled = true
    }
    
    @objc func resizeTextFont() {
        UserDefaults.standard.setValue( contetTextSize.rawValue , forKey: "contet_text_size")
        
        switch self.contetTextSize {
        case .firstFont:
            self.contetTextSize = .secondFont
            self.buttonHeightConstraits.constant = 60
            self.viewsWidthConstraits.constant = 24
            self.setResizeValue(value: 2)
            self.viewsIconImageView.image = UIImage(named: "views2x_icon")
            self.likeButton.setImage( UIImage(named: localNews?.userAction == 1 ? "like2x_icon" : "unlike2x_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
            self.bookmarkButton.setImage( UIImage(named: localNews!.isBookmarked ? "bookmark2x" : "unselected2x_bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal )

        case .secondFont:
            self.contetTextSize = .thirdFont
            self.buttonHeightConstraits.constant = 69
            self.viewsWidthConstraits.constant = 30
            self.setResizeValue(value: 3)
            self.viewsIconImageView.image = UIImage(named: "views3x_icon")
            self.likeButton.setImage( UIImage(named:  localNews?.userAction == 1 ? "like3x_icon" : "unlike3x_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
            self.bookmarkButton.setImage( UIImage(named: localNews!.isBookmarked ? "bookmark3x" : "unselected3x_bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal )
        case .thirdFont:
            self.contetTextSize = .firstFont
            self.viewsWidthConstraits.constant = 17
            self.buttonHeightConstraits.constant = 44
            self.setResizeValue(value: 1)
            self.viewsIconImageView.image = UIImage(named: "views_Icon")
            self.likeButton.setImage( UIImage(named: localNews?.userAction == 1 ? "like_icon" : "unlike_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
            self.bookmarkButton.setImage( UIImage(named: localNews!.isBookmarked ? "bookmark" : "unselected_bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal )
        }
    }
    
    func setResizeValue(value: CGFloat){
        self.titleLabel.font = .boldSystemFont(ofSize: 16 * value)
        self.creatorLabel.font =  .boldSystemFont(ofSize: 14 * value)
        self.contentTextView.font = UIFont(name: "Helvetica", size: 11 * value)
        self.viewsLabel.font = .boldSystemFont(ofSize: 10 * value)
        self.dateLabel.font = .boldSystemFont(ofSize: 11 * value)
        self.likeLabel.font = .boldSystemFont(ofSize: 13 * value)
        self.headerViewHeightConstraits.constant = 12 * value
        self.urlButton.titleLabel?.font = .boldSystemFont(ofSize: 14 * value)
        self.collectionTextSize = 12 * value
        self.bookmarkAndLikeConstraits.constant = 30 * value
        self.updateCategoriesCollectionView()
    }
    
    @objc func shareNewsScreen() {
        
        let currentText = "Shared via CoinConvertor:\n\(news!.title)\n\(news!.link)"
        ShareManager.shareText( self, text: currentText )
    }
}


//MARK: - UICollectionViewDelegate -

extension NewsContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout   {
    func collectionView(collectionviewcell: CategorieCollectionViewCell?, index: Int, didTappedInTableViewCell: BaseTableViewCell) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCategori", for: indexPath) as? CategorieCollectionViewCell {
            cell.setDate(categoria: news!.categories[indexPath.row])
            cell.categoriesLabel.font = .boldSystemFont(ofSize: collectionTextSize)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NewsCacher.shared.searchText = news!.categories[indexPath.row]
        self.goToNewViewController()
    }
}


// MARK: - Delegate Methods-

extension NewsContentViewController {
    
    @objc func liked() {
        likeButton.isUserInteractionEnabled = false
        
        if let delegate = delegate, let indexNews = self.indexNews {
            delegate.liked(row: indexNews)
            
            if localNews?.userAction != 1 {
                self.likeLabel.text = (localNews!.liked + 1).getString()
                switch contetTextSize {
                case .firstFont:
                    self.likeButton.setImage( UIImage(named: "like_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
                case .secondFont:
                    self.likeButton.setImage( UIImage(named: "like2x_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
                case .thirdFont:
                    self.likeButton.setImage( UIImage(named: "like3x_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
                }
                localNews?.userAction = 1
            } else {
                self.likeLabel.text = (localNews!.liked - 1).getString()
                if localNews!.liked - 1 == 0 { self.likeLabel.text = "" }
                switch contetTextSize {
                case .firstFont:
                    self.likeButton.setImage( UIImage(named: "unlike_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
                case .secondFont:
                    self.likeButton.setImage( UIImage(named: "unlike2x_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
                case .thirdFont:
                    self.likeButton.setImage( UIImage(named: "unlike3x_icon")?.withRenderingMode(.alwaysTemplate), for: .normal )
                }
                localNews?.userAction = 0
            }
        }
    }

    @objc func bookmarkTapped() {
        self.bookmarkButton.isUserInteractionEnabled = true

        if let delegate = delegate,let indexNews = self.indexNews  {
            delegate.bookmarkTapped(row: indexNews)
            
            switch contetTextSize {
            case .firstFont:
                self.bookmarkButton.setImage( UIImage(named: localNews!.isBookmarked ? "unselected_bookmark" : "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal )
            case .secondFont:
                self.bookmarkButton.setImage( UIImage(named: localNews!.isBookmarked ? "unselected2x_bookmark" : "bookmark2x")?.withRenderingMode(.alwaysTemplate), for: .normal )
            case .thirdFont:
                self.bookmarkButton.setImage( UIImage(named: localNews!.isBookmarked ? "unselected3x_bookmark" : "bookmark3x")?.withRenderingMode(.alwaysTemplate), for: .normal )
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 ) {
            self.bookmarkButton.isUserInteractionEnabled = true
        }
    }
    func watched() {
        if let delegate = delegate,let indexNews = self.indexNews  {
            delegate.wathed(row: indexNews)
        }
    }
    
    @objc func goToNewViewController() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.seaarchtTextChanged), object: nil)
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

//Helper
enum ContentNewsSize: String, Codable  {
    case firstFont
    case secondFont
    case thirdFont
    
    func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
}

// MARK: - Ads Methods -

extension NewsContentViewController {
    
    func checkUserForAds() {
        AdsManager.shared.checkUserForAds(zoneName: .newArticle) { adsView in
            self.adsViewForDetailNews = adsView
            self.setupAds()
        }
    }
    func setupAds() {
        guard let adsViewForAccount = adsViewForDetailNews else { return }
        
        self.view.addSubview(adsViewForAccount)
        
        adsViewForAccount.translatesAutoresizingMaskIntoConstraints = false
        adsViewForAccount.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        view.rightAnchor.constraint(equalTo: adsViewForAccount.rightAnchor, constant: 10).isActive = true
        tabBarController?.tabBar.topAnchor.constraint(equalTo: adsViewForAccount.bottomAnchor,constant: 48).isActive = true
        bottomContentInsets = 200
    }
}
