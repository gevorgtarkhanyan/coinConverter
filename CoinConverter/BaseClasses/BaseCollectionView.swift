//
//  BaseCollectionView.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 24.12.21.
//

import UIKit
import Localize_Swift

class BaseCollectionView: UICollectionView {

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Awake from NIB
    override func awakeFromNib() {
        super.awakeFromNib()
        startupSetup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Startup sefault setup
extension BaseCollectionView {
    @objc public func startupSetup() {
        changeColors()
        addObservers()
    }

    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeColors), name: Notification.Name(ConverterNotification.themeChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name(LCLLanguageChangeNotification), object: nil)
    }

    @objc fileprivate func themeChanged() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.changeColors()
        }
    }

    @objc public func changeColors() {
       backgroundColor = darkMode ? .tableCellBackgroundDark : .tableCellBackgroundLight
    }

    @objc public func languageChanged() { }
}


class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        let itemSpace = itemSize.width + minimumLineSpacing
        var currentItemIdx = round(collectionView.contentOffset.x / itemSpace)

        // Skip to the next cell, if there is residual scrolling velocity left.
        // This helps to prevent glitches
        let vX = velocity.x
        if vX > 0 {
            currentItemIdx += 1
        } else if vX < 0 {
            currentItemIdx -= 1
        }

        let indexItemOffset = currentItemIdx * itemSpace
        let itemCenterOffset = (UIScreen.main.bounds.width - itemSize.width) / 2
        let offsetX = indexItemOffset - itemCenterOffset + minimumLineSpacing

        return CGPoint(x: offsetX, y: parent.y)
    }
}
