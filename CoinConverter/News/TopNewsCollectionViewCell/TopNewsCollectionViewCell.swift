//
//  TopNewsCollectionViewCell.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 29.12.21.
//

import UIKit

protocol TopNewsViewCellDelegate: AnyObject {
    func liked (row: Int)
    func bookmarkTapped(row: Int)
}

class TopNewsCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewImageView: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var bookmarkBackgroundView: UIView!
    @IBOutlet weak var likeButtonBackgroundView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var sourceLabel: UILabel!
    
    static var height: CGFloat = 239
    static var width: CGFloat = 283
    
    var indexPath: IndexPath?
    weak var delegate: TopNewsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
        
    }
    
    func initialSetup() {
        self.roundCorners(radius: 10)
        self.bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
        self.viewImageView.image = UIImage(named: "views_Icon")?.withRenderingMode(.alwaysTemplate)
        self.contentBackgroundView?.roundCorners([.topLeft,.topRight], radius: 10)
        self.contentLabel.font = .boldSystemFont(ofSize: 14)
        let likeGetchur = UITapGestureRecognizer.init(target: self, action: #selector(liked))
        self.likeButtonBackgroundView.addGestureRecognizer(likeGetchur)
        let bookmarkGetchur = UITapGestureRecognizer.init(target: self, action: #selector(bookmarkTapped))
        self.bookmarkBackgroundView.addGestureRecognizer(bookmarkGetchur)
    }
    
    func setData(news: NewsModel, indexPath: IndexPath) {
        self.topImageView.sd_setImage(with: URL(string: news.image), placeholderImage: UIImage(named: "news_placeholder"), completed: nil)
        self.indexPath = indexPath
        self.viewsLabel.text    =  news.watched.getString().localized()
        self.likeLabel.text     =  news.liked.getString().localized()
        self.dateLabel.text     =  news.date.getDateFromUnixTime()
        self.contentLabel.text  =  news.title.localized()
        self.sourceLabel.text   =  news.source.localized()
        self.dateLabel.text     =  news.date.getDateFromUnixTime()
        self.bookmarkButton.setImage( news.isBookmarked ? UIImage(named: "bookmark") : UIImage(named: "unselected_bookmark") , for: .normal)
        self.likeButton.setImage(news.userAction == 1  ? UIImage(named: "like_icon")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "unlike_icon")?.withRenderingMode(.alwaysTemplate)  , for: .normal )
        self.likeButton.addTarget(self, action: #selector(liked), for: .touchUpInside)
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }
    
    // MARK: - Delegate Methods-
    @objc func liked() {
        if let delegate = delegate, let indexPath = indexPath {
            delegate.liked(row: indexPath.row)
        }
    }
    @objc func bookmarkTapped() {
        if let delegate = delegate,let indexPath = indexPath {
            delegate.bookmarkTapped(row: indexPath.row)
        }
    }
}
