//
//  CoinChartViewController.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import Charts

class CoinChartViewController: BaseViewController {
    
    @IBOutlet weak var coinChartTableView: BaseTableView!
    @IBOutlet weak var timeView: GraphTimeView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var settingsButton: GradientButton!
    @IBOutlet weak var dateLabel: BaseLabel!
    @IBOutlet weak var priceLabel: BaseLabel!
    @IBOutlet weak var chartContainerView: BaseView!
    @IBOutlet weak var loadingView: LoadingView!
    
    @IBOutlet weak var linkParentView: UIView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var redditButton: UIButton!
    @IBOutlet weak var exploreatursLabel: BaseLabel!
    @IBOutlet weak var linkTableView: BaseTableView!
    
    @IBOutlet weak var linkTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exploreatursHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var websiteButtonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var chartData: [ChartModel] = []
    private var currentTime = GraphTimeData.week
    private var blurView: UIVisualEffectView!
    private var coinsDatas = [(coin: CoinModel, data: [ChartDataEntry])]()
    private var chartSavedData = [CoinModel: [GraphTimeData: (coin: CoinModel, data: [ChartDataEntry])]]()
    
    private var noWiFyIcon: UIBarButtonItem!
    private var selectedCoins: [CoinModel] = []
    private var coin: CoinModel?
    private var expLinks: [String] {
        return selectedCoins.first?.explorerLinks ?? []
    }
    
    private var verticalLineIsOn: Bool {
        return UserDefaults.standard.bool(forKey: DefaultCases.coinSettingsVertical.rawValue)
    }
    private var horizontalLineIsOn: Bool {
        return UserDefaults.standard.bool(forKey: DefaultCases.coinSettingsHorizontal.rawValue)
    }
    private var lineGraphIsOn: Bool {
        return UserDefaults.standard.bool(forKey: DefaultCases.coinSettingsLineGraph.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        resetValues()
        setupTableView()
        setupNavigation()
        initialSetup()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        changeBlureViewSize(with: size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showInternetIcon()
        setupGraph(for: currentTime)
        timeSelected(time: currentTime)
        
        if coinsDatas.count == 0 {
            chartView.clear()
        }
    }
    
    private func setupBlureEffect() {
        blurView = UIVisualEffectView(frame: UIScreen.main.bounds)
        view.addSubview(blurView)
        blurView.alpha = 0
        blurView.effect = UIBlurEffect(style: .dark)
        view.bringSubviewToFront(blurView)
        
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.blurView.alpha = self.darkMode ? 0.4: 0.7
        }, completion: nil)
    }
    
    private func changeBlureViewSize(with size: CGSize) {
        if blurView != nil {
            blurView.frame.size = size
        }
    }
    
    func setupData() {
        if let coin = coin {
            chartData = ChartDataSource.getChartData(for: coin)
            linkSetup()
            DispatchQueue.main.async {
                self.coinChartTableView.reloadData()
            }
        }
    }
    
    func initialSetup() {
        chartView.backgroundColor = darkMode ? .tableCellBackgroundDark : .white
    }
    
    func setupTableView() {
        coinChartTableView.delegate = self
        coinChartTableView.dataSource = self
        coinChartTableView.register(UINib(nibName: "CoinChartCell", bundle: nil), forCellReuseIdentifier: "chartCell")
        tableViewHeightConstraint.constant = CGFloat(chartData.count) * CoinChartCell.height
    }
    
    func setupNavigation() {
        title = coin?.name ?? "Coin Chart"
        noWiFyIcon = UIBarButtonItem(image: UIImage(named: "no_wifi"), style: .done, target: self, action: nil)
    }
    
    private func showInternetIcon() {
        if Connectivity.shared.isConnectedToInternet() {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = noWiFyIcon
        }
    }
    
    func setupGraph(for time: GraphTimeData) {
        chartView.isHidden = true
        chartView.delegate = self
        
        selectDefaultTime(time: time)
    }
    
    private func selectDefaultTime(time: GraphTimeData) {
        chartView.clear()
        timeView.selectTime(currentTime)
        timeView.delegate = self
    }
    
    @IBAction func settingsButtonTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ChartSettingsViewController") as? ChartSettingsViewController {
            setupBlureEffect()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    // MARK: -- Get chart data from server
    private func getChartDataFromServer(timeZone: GraphTimeData, received: @escaping(Bool) -> Void) {
        var receivedData = [(coin: CoinModel, data: [ChartDataEntry])]()
        if let coin = coin {
            if let selectedCoin = chartSavedData[coin], let graphData = selectedCoin[timeZone] {
                let data = graphData.data
                receivedData.append((coin: coin, data: data))
                if receivedData.count == self.selectedCoins.count {
                    self.coinsDatas = receivedData
                    received(true)
                }
            } else {
                loadingView.startAnimation(for: view)
                NetworkManager.shared.getChart(coinId: coin.coinId, period: timeZone.rawValue, success: { (graphData) in
                    let data = graphData.map { (item) -> ChartDataEntry in
                        return ChartDataEntry(x: item.date, y: item.usd)
                    }
                    
                    if data.count > 0 {
                        if let _ = self.chartSavedData[coin] {
                            self.chartSavedData[coin]![timeZone] = (coin: coin, data: data)
                        } else {
                            let value = [timeZone: (coin: coin, data: data)]
                            self.chartSavedData[coin] = value
                        }
                        
                        receivedData.append((coin: coin, data: data))
                        
                        if receivedData.count == self.selectedCoins.count {
                            self.coinsDatas = receivedData
                            received(true)
                        }
                    } else {
                        self.chartView.clear()
                        received(false)
                    }
                    self.loadingView.stopLoading(for: self.view)
                    self.showInternetIcon()
                }) { (error) in
                    self.showInternetIcon()
                    self.loadingView.stopLoading(for: self.view)
                    received(false)
                    self.showWarningAlert(title: nil, message: error)
                    debugPrint("Chart error ---\(error)")
                }
            }
        }
    }
    
    // MARK: -- Draw graph
    
    private func drawGraph() {
        chartView.isHidden = false
        var dataSets = [LineChartDataSet]()
        for (i, item) in coinsDatas.enumerated() {
            var chartDataSet = LineChartDataSet(entries: item.data, label: "\(item.coin.name) (\(item.coin.symbol))")
            chartDataSet.sort { $0.x < $1.x }
            dataSets.append(chartDataSet)
            
            let lineGraph = lineGraphIsOn
            chartDataSet.fillAlpha = 0.6
            chartDataSet.drawIconsEnabled = false
            chartDataSet.drawValuesEnabled = false
            
            chartDataSet.drawFilledEnabled = !lineGraph
            
            let colorArray = UIColor.graphLineGradientColors[i]
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.circleRadius = 4.0
            chartDataSet.circleHoleRadius = 2.0
            chartDataSet.lineWidth = lineGraph ? 1 : 0
            chartDataSet.setColor(colorArray.first!)
            
            let gradientColors = colorArray.map { $0.cgColor } as CFArray
            let colorLocations: [CGFloat] = [0, 1]
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
                chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 0)
            }
            
            chartDataSet.highlightColor = darkMode ? .white : .textBlack
            chartDataSet.highlightLineWidth = 0.5
        }
        
        chartView.chartDescription?.text = ""
        chartView.data = LineChartData(dataSets: dataSets)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = DateChartFormatter()
        xAxis.axisLineColor = darkMode ? .white : .black
        xAxis.labelTextColor = darkMode ? .white : .black
        xAxis.enabled = horizontalLineIsOn
        
        chartView.legend.textColor = darkMode ? .white : .black
        chartView.leftAxis.axisLineColor = darkMode ? .white : .black
        chartView.rightAxis.drawLabelsEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = PriceChartFormatter()
        leftAxis.axisLineColor = darkMode ? .white : .black
        leftAxis.labelTextColor = darkMode ? .white : .black
        leftAxis.labelPosition = .outsideChart
        leftAxis.enabled = verticalLineIsOn
        
        if coinsDatas.count == 0 {
            chartView.clear()
        }
        
    }
    
}

extension CoinChartViewController: ChartSettingsViewControllerDelegate {
    func settingsChanged(horizontalLine: Bool, verticalLine: Bool, lineGraph: Bool) {
        UserDefaults.standard.set(lineGraph, forKey: DefaultCases.coinSettingsLineGraph.rawValue)
        UserDefaults.standard.set(verticalLine, forKey: DefaultCases.coinSettingsVertical.rawValue)
        UserDefaults.standard.set(horizontalLine, forKey: DefaultCases.coinSettingsHorizontal.rawValue)
        drawGraph()
    }
    
    func hideBlurView() {
        if let view = blurView {
            view.removeFromSuperview()
        }
    }
}

// MARK: - Link Setup
extension CoinChartViewController {
    private func linkSetup() {
        websiteButtonsSetup()
        linkParentView.backgroundColor = darkMode ? .tableCellBackgroundDark : .tableCellBackgroundLight
        linkParentView.layer.cornerRadius = 10
        exploreatursLabel.setLocalizableText("Explorers")
        
        exploreatursHeightConstraint.constant = expLinks.isEmpty ? 0 : 30
        linkTableViewHeightConstraint.constant = CGFloat(expLinks.count * 35)
        
        linkTableView.delegate = self
        linkTableView.dataSource = self
        linkTableView.separatorStyle = .none
        linkTableView.reloadData()
        view.layoutIfNeeded()
    }
    
    private func websiteButtonsSetup() {
        guard let coin = selectedCoins.first else { return }
        
        websiteButton.setImage(UIImage(named: "website"), for: .normal)
        twitterButton.setImage(UIImage(named: "twitter"), for: .normal)
        redditButton.setImage(UIImage(named: "reddit"), for: .normal)
        
        websiteButton.addTarget(self, action: #selector(buttunAction(sender:)), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(buttunAction(sender:)), for: .touchUpInside)
        redditButton.addTarget(self, action: #selector(buttunAction(sender:)), for: .touchUpInside)
        
        websiteButton.isHidden = coin.websiteUrl == nil
        twitterButton.isHidden = coin.twitterUrl == nil
        redditButton.isHidden = coin.redditUrl == nil
        let buttonsIsHidden = websiteButton.isHidden && twitterButton.isHidden && redditButton.isHidden
        linkParentView.isHidden = buttonsIsHidden && expLinks.isEmpty
        
        websiteButtonsHeightConstraint.constant = buttonsIsHidden ? 0 : 30
    }
    
    @objc private func buttunAction(sender: BaseButton) {
        var urlStr = ""
        guard let coin = selectedCoins.first else { return }
        
        switch sender.tag {
        case 0:
            urlStr = coin.websiteUrl ?? ""
            openApp(appString: "nil", webString: urlStr)
        case 1:
            urlStr = coin.twitterUrl ?? ""
            let fileURL = URL(fileURLWithPath: urlStr)
            openApp(appString: "twitter:///user?screen_name=\(fileURL.lastPathComponent)", webString: urlStr)
        case 2:
            urlStr = coin.redditUrl ?? ""
            let fileURL = URL(fileURLWithPath: urlStr)
            openApp(appString: "reddit:///r/\(fileURL.lastPathComponent)", webString: urlStr)
        default:
            return
        }
    }

    private func openApp(appString: String, webString: String) {
        guard let appURL = URL(string: appString), let webURL = URL(string: webString) else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            //redirect to browser because the user doesn't have application
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL)
            }
        }
    }
}


// MARK: -- Table View delegate and data source methods
extension CoinChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = tableView == linkTableView ? expLinks.count : chartData.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == linkTableView {
            let cell = BaseTableViewCell()
            cell.textLabel?.text = expLinks[indexPath.row]
            cell.textLabel?.textColor = darkMode ? .white : .black
            cell.backgroundColor = .clear
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell") as? CoinChartCell else { return BaseTableViewCell() }
        cell.setup(with: chartData, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == linkTableView {
            openURL(urlString: expLinks[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CoinChartCell.height
    }
    
}

// MARK: - Delegates
extension CoinChartViewController: GraphTimeViewDelegate {
    func timeSelected(time: GraphTimeData) {
        guard selectedCoins.count != 0 else { return }
        getChartDataFromServer(timeZone: time) { (received) in
            if received {
                self.currentTime = time
                self.setupGraph(for: self.currentTime)
                self.drawGraph()
                self.resetValues()
            }
        }
    }
    
    func resetValues() {
        priceLabel.text = ""
        dateLabel.text = ""
    }
}

extension CoinChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let time = entry.x.getDateFromUnixTime()
        let price = entry.y
        dateLabel.text = time
        priceLabel.text = price.getString() + " $"
    }
}

// MARK: Set Data
extension CoinChartViewController {
    public func setCoin(with coin: CoinModel?) {
        guard let coin = coin else { return }
        self.coin = coin
        self.selectedCoins.append(coin)
    }
}

// MARK: - Helpers
@objc(PriceChartFormatter)
public class PriceChartFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.getString() + "$"
    }
}

@objc(DateChartFormatter)
public class DateChartFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value)))
    }
}
