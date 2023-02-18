//
//  GraphTimeView.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/19/19.
//

import UIKit

protocol GraphTimeViewDelegate: class {
    func timeSelected(time: GraphTimeData)
}

class GraphTimeView: BaseView {
    
    @IBOutlet weak var timeParentStackView: UIStackView!
    @IBOutlet var contentView: UIView!
    
    private let timeData = GraphTimeData.allCases
    private var selectedButton: GraphButton?
    private(set) var currentTime = GraphTimeData.day
    private var timeButtons: [GraphButton] = []
    
    weak var delegate: GraphTimeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GraphTimeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupDigits()
    }
    
    private func setupDigits() {
        for (index, digit) in timeData.enumerated() {
            let digitButton = GraphButton(frame: .zero)
            timeParentStackView.addArrangedSubview(digitButton)
            timeButtons.append(digitButton)
            
            digitButton.tag = index
            digitButton.setTitle(digit.rawValue, for: .normal)
            digitButton.addTarget(self, action: #selector(digitTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func digitTapped(_ sender: GraphButton) {
        if timeData.indices.contains(sender.tag), selectedButton != sender {
            selectedButton?.setSelected(false)
            selectedButton = sender
            selectedButton?.setSelected(true)
            currentTime = timeData[sender.tag]
            delegate?.timeSelected(time: currentTime)
        }
    }
    
    public func selectTime(_ time: GraphTimeData) {
        let index = timeData.firstIndex {$0 == time}
        digitTapped(timeButtons[index ?? 0])
    }
}
