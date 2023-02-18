//
//  MaskView.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 17.02.22.
//

import Foundation


import UIKit

class MaskView: UIView {
    
    private var action: Selector?
    private var target: AnyObject?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init?(target: AnyObject?, action: Selector?) {
        self.init()
        self.target = target
        self.action = action
        awakeFromNib()
    }

    // MARK: - Awake from NIB
    override func awakeFromNib() {
        super.awakeFromNib()
        startupSetup()
    }
    
    private func startupSetup() {
        addGestures()
        backgroundColor = .clear
    }
    
    //MARK: - add gesture
    fileprivate func addGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        addGestureRecognizer(getSwipeGesture(for: .down))
        addGestureRecognizer(getSwipeGesture(for: .up))
        addGestureRecognizer(getSwipeGesture(for: .left))
        addGestureRecognizer(getSwipeGesture(for: .right))
    }
    
    private func getSwipeGesture(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: target, action: action)
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizer.direction = direction
        return swipeGestureRecognizer
    }
}
