//
//  UITableView_Extension.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/4/19.
//

import UIKit

extension UITableView {
    
    enum ScrollsTo {
        case top, bottom
    }
    
    //MARK: - Animation
    func animate(duration: TimeInterval = 0.8,
                 delay: TimeInterval = 1,
                 deltaDelay: TimeInterval = 0.08,
                 springWithDamping: CGFloat = 0.7,
                 springVelocity: CGFloat = 0) {
        
        var changeAbleDelay: TimeInterval = delay
        self.reloadData()
        let cells = self.visibleCells
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: cell.transform.ty + 100).scaledBy(x: 1.3, y: 1.3)
            cell.alpha = 0
        }
        
        for cell in cells {
            UIView.animate(withDuration: duration,
                           delay: changeAbleDelay * deltaDelay,
                           usingSpringWithDamping: springWithDamping,
                           initialSpringVelocity: springVelocity,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
                            cell.alpha = 1
            },
                           completion: nil)
            
            changeAbleDelay += 1
        }
    }
    
    //MARK: - Scrolling
    func scroll(to: ScrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            switch to {
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRowSafely(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections - 1))
                    self.scrollToRowSafely(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    func scrollToRowSafely(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        if indexPathExists(with: indexPath) {
            DispatchQueue.main.async() {
            self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
            }
        }
    }
    
    //for the safe scrolling
    func indexPathExists(with indexPath: IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
    
    func reloadDataScrollUp() {
        reloadData()
        scroll(to: .top, animated: false)
    }
    
    
}
