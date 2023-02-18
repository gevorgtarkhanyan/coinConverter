//
//  TopNewsTableViewCell.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 03.01.22.
//

import UIKit

protocol TopNewsTableViewCellDelegate: AnyObject {
    func liked (row: Int)
    func bookmarkTapped(row: Int)
    func goToDetail(row: Int)
}

class TopNewsTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var topNewsCollectionView: BaseCollectionView!
    private var news: [NewsModel] = []
    weak var delegate: TopNewsTableViewCellDelegate?
    
    static var height: CGFloat = 260
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    override func initialSetup() {
        super.initialSetup()
        self.configCollectionLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.topNewsCollectionView.backgroundColor = .clear
    }
    
    func configCollectionLayout() {
        
        self.topNewsCollectionView.delegate = self
        self.topNewsCollectionView.dataSource = self
        self.topNewsCollectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        let flowLayout = SnappingCollectionViewLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: TopNewsCollectionViewCell.width, height: TopNewsCollectionViewCell.height)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        self.topNewsCollectionView.collectionViewLayout = flowLayout
        self.topNewsCollectionView.backgroundColor = .clear
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: TopNewsCollectionViewCell.name, bundle: nil)
        self.topNewsCollectionView.register(cellNib, forCellWithReuseIdentifier: TopNewsCollectionViewCell.name)
    }
    
    func setData(news: [NewsModel]) {
        self.news = news
        self.topNewsCollectionView.reloadData()
    }
}


//MARK: - UICollectionViewDelegate  -

extension TopNewsTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopNewsCollectionViewCell.name, for: indexPath) as? TopNewsCollectionViewCell {
            cell.setData(news: news[indexPath.row], indexPath: indexPath)
            cell.backgroundColor = .clear
            cell.delegate = self
            return cell
        }
        return TopNewsCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetail(row: indexPath.row)
    }
}


extension TopNewsTableViewCell: TopNewsViewCellDelegate {
    func liked(row: Int) {
        if let delegate = delegate{
            delegate.liked(row: row)
        }
    }
    
    func bookmarkTapped(row: Int) {
        if let delegate = delegate {
            delegate.bookmarkTapped(row: row)
        }
    }
    func goToDetail(row: Int) {
        if let delegate = delegate {
            delegate.goToDetail(row: row)
        }
    }
    
}
