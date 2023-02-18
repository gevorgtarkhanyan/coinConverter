//
//  EmailDataSource.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/18/19.
//

import Foundation

enum MailApplicationSettings: String {
    case mail = "mailto:"
    case gmail = "googlegmail:///co"
    case yahoo = "ymail://mail/compose"
    case outlook = "ms-outlook://compose"
    case inbox = "inbox-gmail://co"
}
