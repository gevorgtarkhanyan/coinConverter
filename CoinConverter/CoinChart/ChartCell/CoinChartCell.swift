//
//  CoinChartCell.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/4/19.
//

import UIKit

class CoinChartCell: BaseTableViewCell {
    
    @IBOutlet weak var keyLabel: BaseLabel!
    @IBOutlet weak var valueLabel: BaseLabel!
    
    static let height: CGFloat = 32
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with data: [ChartModel], for indexPath: IndexPath) {
        let currentData = data[indexPath.row]
        setupInterface(for: currentData, with: data, indexPath: indexPath)

        keyLabel.text = currentData.key
        
        if currentData.key.contains("Change") {
            valueLabel.text = currentData.value.contains("-") ? "\(currentData.value)%" : "+\(currentData.value)%"
            valueLabel.textColor = currentData.value.contains("-") ? .workerRed : .workerGreen
        } else {
            valueLabel.textColor = darkMode ? .white : .black
            valueLabel.text = currentData.value
        }
    }
    
    private func setupInterface(for currentData: ChartModel, with data: [ChartModel], indexPath: IndexPath) {
        let lastIndex = data.count - 1
        
        if data.count != 0 {
            if currentData === data[lastIndex] {
                if lastIndex == 0 {
                    roundCorners([.bottomLeft, .bottomRight, .topLeft, .topRight], radius: Constants.radius)
                } else {
                    roundCorners([.bottomLeft, .bottomRight], radius: Constants.radius)
                }
            } else {
                if currentData === data[0] {
                    roundCorners([.topLeft, .topRight], radius: Constants.radius)
                } else {
                    roundCorners([.topRight, .topLeft, .bottomRight, .bottomLeft], radius: 0)
                }
                addSeparatorView(from: keyLabel, to: valueLabel)
            }
        }
    }
    
}
