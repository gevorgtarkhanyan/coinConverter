
//  NewsTableViewCell.swift
//  CoinConverter
//
//  Created by Vazgen Hovakimyan on 22.12.21.
//  Copyright © 2021 WitPlex. All rights reserved.
//
//
import UIKit

protocol NewsTableViewCellDelegate: AnyObject {
    func liked (row: Int)
    func bookmarkTapped(row: Int)
}

class NewsTableViewCell: BaseTableViewCell {
    
    //MARK: - Views -
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookmarkButton: NewsButton!
    @IBOutlet weak var viewIcon: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likeButtonBackgroundView: UIView!
    @IBOutlet weak var likeButton: NewsButton!
    @IBOutlet weak var likeLabel: NewsLabel!
    @IBOutlet weak var bookmarkBackgroundView: UIView!
    @IBOutlet weak var contentLabel: BaseLabel!
    @IBOutlet weak var bootomView: UIView!
    @IBOutlet weak var sourceLabel: UILabel!
    
    static var height: CGFloat = 125
    
    var row: Int?
    weak var delegate: NewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.likeLabel.text = ""
    }
    
    override func initialSetup() {
        super.initialSetup()
        self.bookmarkButton.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.likeButton.setImage(UIImage(named: "unlike_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.viewIcon.image = UIImage(named: "views_Icon")
        //  self.bookmarkButton.tintColor = .black
        self.viewIcon.tintColor = .black
        let likeGetchur = UITapGestureRecognizer.init(target: self, action: #selector(liked))
        self.likeButtonBackgroundView.addGestureRecognizer(likeGetchur)
        let bookmarkGetchur = UITapGestureRecognizer.init(target: self, action: #selector(bookmarkTapped))
        self.bookmarkBackgroundView.addGestureRecognizer(bookmarkGetchur)
        let enptyGetchur = UITapGestureRecognizer.init(target: self, action: #selector(enptyAction))
        self.bootomView.addGestureRecognizer(enptyGetchur)
        self.newsImageView.roundCorners(radius: 10)
        DispatchQueue.main.async {
            self.dateLabel.textColor = .lightGray
            self.viewsLabel.textColor = .lightGray
            self.sourceLabel.textColor = .lightGray
        }
    }
    
    func setData(news: NewsModel, row: Int) {
        self.newsImageView.sd_setImage(with: URL(string: news.image), placeholderImage: UIImage(named: "news_placeholder"), completed: nil)
        self.row = row
        self.viewsLabel.text = news.watched.getString()
        if news.liked != 0 {  self.likeLabel.setLocalizableText(news.liked.getString()) }
        self.dateLabel.text =  news.date.getDateFromUnixTime()
        self.contentLabel.setLocalizableText(news.title)
        self.sourceLabel.text = news.source
        
        self.bookmarkButton.setImage( news.isBookmarked ? UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "unselected_bookmark")?.withRenderingMode(.alwaysTemplate) , for: .normal)
        self.likeButton.setImage(news.userAction == 1  ? UIImage(named: "like_icon")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "unlike_icon")?.withRenderingMode(.alwaysTemplate)  , for: .normal )
        self.likeButton.addTarget(self, action: #selector(liked), for: .touchUpInside)
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        
    }
    
    // MARK: - Delegate Methods-
    @objc func liked() {
        if let delegate = delegate, let row = row {
            delegate.liked(row: row)
        }
    }
    @objc func bookmarkTapped() {
        if let delegate = delegate,let row = row {
            delegate.bookmarkTapped(row: row)
        }
    }
    @objc func enptyAction() {}
}

