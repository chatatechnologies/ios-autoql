//
//  ChatTableModel.swift
//  chata
//
//  Created by Vicente Rincon on 13/03/20.
//

import Foundation
struct ChatTableColumn {
    var name: String
    var type: ChatTableColumnType
    var originalName: String
    var rows: [[String]]
    var webView: String
    init(
        name: String = "",
        type: ChatTableColumnType = .defaultType,
        rows: [[String]] = [],
        webView: String = "",
        originalName: String = ""
    ) {
        self.name = name.replaceUnder()
        self.type = type
        self.rows = rows
        self.webView = webView
        self.originalName = originalName
    }
}
enum ChatTableColumnType: String, CaseIterable{
    case date = "DATE"
    case string = "STRING"
    case quantity = "QUANTITY"
    case percent = "PERCENT"
    case dollar = "DOLLAR_AMT"
    case ratio = "RATIO"
    case defaultType = ""
    static func withLabel(_ str: String) -> ChatTableColumnType {
        return self.allCases.first {
            "\($0.description)" == str
        } ?? defaultType
    }
    var description: String {
        return self.rawValue
    }
}
