//
//  SettingsCell.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/17/19.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    func offlineModeTapped(with sender: BaseSwitch)
    func showSubscriptionPopup()
    func cellTappedFiveTimes(indexPath: IndexPath)

}

class SettingsCell: BaseTableViewCell {

    @IBOutlet weak var iconWidthConstraits: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var settingsInfoLabel: BaseLabel!
    @IBOutlet weak var modeSwitch: BaseSwitch!
    
    weak var delegate: SettingsCellDelegate?
    
    fileprivate var indexPath: IndexPath = IndexPath(row: 0, section: 0)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hideSwitch()
        addGestureRecognizers()
    }
    
    override var frame: CGRect {
          get {
              return super.frame
          }
          set (newFrame) {
              var frame = newFrame
              let newWidth = frame.width * 0.90 // get 80% width here
              let space = (frame.width - newWidth) / 2
              frame.size.width = newWidth
              frame.origin.x += space

              super.frame = frame

          }
      }
    
    fileprivate func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tap.numberOfTapsRequired = 5
        addGestureRecognizer(tap)
    }
    
    override func changeColors() {
        backgroundColor = darkMode ? #colorLiteral(red: 0.1019607843, green: 0.1215686275, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      //  addShadow()
    }

    private func hideSwitch() {
        modeSwitch.isHidden = true
    }
    
    private func showSwitch(row: Int) {
        modeSwitch.isHidden = false
        switch row {
        case 0:
            modeSwitch.isOn = darkMode
        case 1:
            modeSwitch.isOn = offlineMode
        default:
            modeSwitch.isOn = removeAds
        }
    }
    
    @IBAction func switchTapped(sender: BaseSwitch) {
        var bool: Bool
        let mode = Mode(rawValue: sender.tag)
        if mode == .dark {
            darkMode.toggle()
            bool = darkMode
        } else  if mode == .offline {
            offlineMode.toggle()
            bool = offlineMode
            if !offlineMode {
                Defaults.removeAllData()
            }
            delegate?.offlineModeTapped(with: sender)
        } else {
            guard subscribed else {
                if sender.isOn {
                    sender.isOn = false
                    sender.onTintColor = .startGradient
                    delegate?.showSubscriptionPopup()
                }
                return }
            removeAds.toggle()
            bool = removeAds
        }
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.modeSwitch.isOn = bool
        }
    }
    
    @objc fileprivate func tapAction(_ sender: UITapGestureRecognizer) {
        delegate?.cellTappedFiveTimes(indexPath: indexPath)
    }
    
    public func setupCell(with data: [SettingsData], item: SettingsData, for indexPath: IndexPath) {
        setupInterface(with: data, indexPath: indexPath)
        self.indexPath = indexPath
        self.iconImageView.image = UIImage(named: item.rawValue)
        switch item {
        case .darkMode, .offlineMode,.adsRemove:
            modeSwitch.tag = indexPath.row
            showSwitch(row: indexPath.row)
            settingsInfoLabel.text = item.localizedRawValue
            iconWidthConstraits.constant = 20
        case .feedback, .rate, .share, .subscription, .languages:
            hideSwitch()
            settingsInfoLabel.text = item.localizedRawValue
            iconWidthConstraits.constant = 20
        case .website:
            let year = Calendar.current.component(.year, from: Date())
            hideSwitch()
            settingsInfoLabel.text = "Witplex © \(year)"
            iconWidthConstraits.constant = 0
        case .appVersion:
            iconWidthConstraits.constant = 0
            hideSwitch()
            #if DEBUG
            settingsInfoLabel.text = item.localizedRawValue + " \(Bundle.main.releaseVersionNumber) Developer version"
            #else
            settingsInfoLabel.text = item.localizedRawValue + " \(Bundle.main.releaseVersionNumber)"
            #endif
        }
    }
    
    private func setupInterface<T: Equatable>(with data: [T], indexPath: IndexPath) {
        let currentData = data[indexPath.row]
        let lastIndex = data.count - 1
        if data.count != 0 {
            if indexPath.section == 0 &&  indexPath.row == 0 {
                roundCorners([.topRight, .topLeft], radius: Constants.radius)
                DispatchQueue.main.async {
                    self.addShadow(cgRect: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height * 0.6))
                }
            } else if indexPath.section == SettingsData.getSettingsData().count - 1 && currentData == data[lastIndex], lastIndex != 0 {
                roundCorners([.bottomRight, .bottomLeft], radius: Constants.radius)
                DispatchQueue.main.async {
                    self.addShadow(cgRect: CGRect(x: 0.0, y: self.bounds.height * 0.4, width: self.bounds.width, height: self.bounds.height * 0.6))
                }
            } else {
                roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
                DispatchQueue.main.async {
                    self.addShadow(cgRect: CGRect(x: 0.0, y: self.bounds.height * 0.3, width: self.bounds.width, height: self.bounds.height * 0.4))
                }
            }
        }
    }
    
}

enum Mode: Int {
    case dark, offline, removeAds
}
