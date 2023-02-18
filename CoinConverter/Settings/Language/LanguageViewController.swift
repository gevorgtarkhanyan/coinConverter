//
//  LanguageViewController.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 02.08.21.
//

import UIKit
import Localize_Swift

class LanguageViewController: BaseViewController {

    // MARK: - Views
    @IBOutlet fileprivate weak var tableView: BaseTableView!

    // MARK: - Properties
    private var languages = ["en", "hy", "fr", "ru", "zh-Hans", "ko", "de","es"]
    
    // MARK: - Static
    static func initializeStoryboard() -> LanguageViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LanguageViewController.name) as? LanguageViewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startupSetup()
    }

    override func languageChanged() {
        navigationItem.title = SettingsData.languages.rawValue.localized()
    }
}

// MARK: - Startup
extension LanguageViewController {
    fileprivate func startupSetup() {
        selectCurrentLanguage()
    }

    fileprivate func selectCurrentLanguage() {
        let currentLanguage = Localize.currentLanguage()
        let index = languages.firstIndex(of: currentLanguage)

        let indexPath = IndexPath(row: index ?? 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - Actions
extension LanguageViewController {
    func getNationalNameForLanguage(_ language: String) -> String {
        print("language", language)
        switch language {
        case "en":
            return "English - English"
        case "hy":
            return "Armenian - Հայերեն"
        case "fr":
            return "French - Français"
        case "zh-Hans":
            return "Chinese - 中文"
        case "ko":
            return "Korean - 한국어"
        case "ru":
            return "Russian - Русский"
        case "de":
            return "German - Deutsch"
        case "es":
            return "Spanish - Española"
        default:
            break
        }
        return language
    }
}

// MARK: - TableView methods
extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.name) as! LanguageTableViewCell
        let language = languages[indexPath.row]

        cell.setData(name: getNationalNameForLanguage(language), indexPath: indexPath, last: false, roundCorners: false)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newLanguage = languages[indexPath.row]
        Localize.setCurrentLanguage(newLanguage)
        UserDefaults(suiteName: "group.com.witplex.MinerBox")?.set(newLanguage, forKey: "appLanguage")
    }
}
