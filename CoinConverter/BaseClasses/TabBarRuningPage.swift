//
//  TabBarRuningPage.swift
//  CoinsConverter
//
//  Created by Vazgen Hovakimyan on 05.01.22.
//

import UIKit

class TabBarRuningPage: NSObject {

    // MARK: - Properties
    fileprivate(set) var selectedPage = TabBarRuningPageType.convertor
    fileprivate(set) var lastSelectedPage = TabBarRuningPageType.convertor


    // MARK: - Static
    static let shared = TabBarRuningPage()

    // MARK: - Init
    fileprivate override init() {
        super.init()
    }
}

// MARK: - Public methods
extension TabBarRuningPage {
    public func changePage(to type: TabBarRuningPageType) {
        selectedPage = type
    }
    public func changeLastPage(to type: TabBarRuningPageType) {
        lastSelectedPage = type
    }
}

// MARK: - Helpers
enum TabBarRuningPageType: Int {
    case news
    case convertor
    case settings
}
