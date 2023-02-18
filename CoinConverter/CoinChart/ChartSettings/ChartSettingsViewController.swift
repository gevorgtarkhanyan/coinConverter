//
//  ChartSettingsViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/23/19.
//

import UIKit

protocol ChartSettingsViewControllerDelegate: class {
    func settingsChanged(horizontalLine: Bool, verticalLine: Bool, lineGraph: Bool)
    func hideBlurView()
}

class ChartSettingsViewController: BaseViewController {

    @IBOutlet weak var mountainButton: GraphButton!
    @IBOutlet weak var lineButton: GraphButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var verticalSwitch: BaseSwitch!
    @IBOutlet weak var horizontalSwitch: BaseSwitch!
    
    weak var delegate: ChartSettingsViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configButtons()
        initialSetup()
        setupGraphImages()
    }
    
    private func setupGraphImages() {
        mountainButton.setImage(UIImage(named: "coin_graph_mountain")?.withRenderingMode(.alwaysTemplate), for: .normal)
        lineButton.setImage(UIImage(named: "coin_graph_line")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    private func initialSetup() {
        view.backgroundColor = .clear
        emptyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePage)))
        
    }
    
    private func configButtons() {
        let lineGraph = UserDefaults.standard.bool(forKey: DefaultCases.coinSettingsLineGraph.rawValue)
        lineButton.setSelected(lineGraph)
        mountainButton.setSelected(!lineGraph)

        verticalSwitch.setOn(UserDefaults.standard.bool(forKey: DefaultCases.coinSettingsVertical.rawValue), animated: true)
        horizontalSwitch.setOn(UserDefaults.standard.bool(forKey: DefaultCases.coinSettingsHorizontal.rawValue), animated: true)
    }
    
    override func hidePage() {
        super.hidePage()
        delegate?.hideBlurView()
    }
    
    @IBAction func switchTapped(_ sender: BaseSwitch) {
        delegate?.settingsChanged(horizontalLine: horizontalSwitch.isOn, verticalLine: verticalSwitch.isOn, lineGraph: lineButton.isSelected)
    }
    
    @IBAction func graphButtonTapped(_ sender: GraphButton) {
        switch sender {
        case mountainButton:
            lineButton.setSelected(false)
            mountainButton.setSelected(true)
            delegate?.settingsChanged(horizontalLine: horizontalSwitch.isOn, verticalLine: verticalSwitch.isOn, lineGraph: lineButton.isSelected)
        case lineButton:
            lineButton.setSelected(true)
            mountainButton.setSelected(false)
            delegate?.settingsChanged(horizontalLine: horizontalSwitch.isOn, verticalLine: verticalSwitch.isOn, lineGraph: lineButton.isSelected)
        default:
            break
        }
    }
    
    @IBAction func mountainButtonTapped() {
        mountainButton.setSelected(!mountainButton.isSelected)
        lineButton.setSelected(false)
    }
    
    @IBAction func lineButtonTapped() {
        lineButton.setSelected(!lineButton.isSelected)
        mountainButton.setSelected(false)
    }
    
}
