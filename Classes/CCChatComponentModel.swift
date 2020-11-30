//
//  ChatComponentModel.swift
//  chata
//
//  Created by Vicente Rincon on 24/02/20.
//

import Foundation
struct ChatComponentModel {
    var type: ChatComponentType
    var text: String
    var user: Bool
    var webView: String
    var numRow: Int
    var options: [String] = []
    var fullSuggestions: [ChatFullSuggestion] = []
    var dataRows: [[String]] = []
    var columns: [ChatTableColumnType] = []
    var columnsInfo: [ChatTableColumn] = []
    var idQuery: String
    var drillDown: Bool
    var isLoading: Bool
    var position: Int
    var biChart: Bool
    var rowsClean: [[String]]
    var numQBoptions: Int
    var referenceID: String
    var groupable: Bool
    init(type: ChatComponentType = .Introduction,
         text: String = "",
         user: Bool = false,
         webView: String = "",
         numRow: Int = 0,
         options: [String] = [],
         fullSuggestions: [ChatFullSuggestion] = [],
         dataRows: [[String]] = [],
         colunms: [ChatTableColumnType] = [],
         idQuery: String = "",
         columnsInfo: [ChatTableColumn] = [],
         drillDown: Bool = false,
         isLoading: Bool = false,
         position: Int = 0,
         biChart: Bool = false,
         rowsClean: [[String]] = [],
         numQBoptions: Int = 0,
         referenceID: String = "",
         groupable: Bool = false
         ) {
        self.type = type
        self.text = text
        self.user = user
        self.webView = webView
        self.numRow = numRow
        self.options = options
        self.fullSuggestions = fullSuggestions
        self.dataRows = dataRows
        self.columns = colunms
        self.idQuery = idQuery
        self.columnsInfo = columnsInfo
        self.drillDown = drillDown
        self.isLoading = isLoading
        self.position = position
        self.biChart = biChart
        self.rowsClean = rowsClean
        self.numQBoptions = numQBoptions
        self.referenceID = referenceID
        self.groupable = groupable
    }
}
struct ChatFullSuggestion {
    var suggestionList: [ChataFullSuggestionItem]
    var start: Int
    var end: Int
    init(suggestionList: [ChataFullSuggestionItem],
         start: Int,
         end: Int) {
        self.suggestionList = suggestionList
        self.start = start
        self.end = end
    }
}
struct ChataFullSuggestionItem {
    var valueLabel: String
    var text: String
    init(
        valueLabel: String = "",
        text: String = ""
    ) {
        self.valueLabel = valueLabel
        self.text = text
    }
}
enum ChatComponentType: String, CaseIterable {
    case Introduction = "text"
    case QueryBuilder = "qb"
    case Webview = "data"
    case Bar = "bar"
    case Line = "line"
    case Column = "column"
    case Pie = "pie"
    case Heatmap = "heatmap"
    case Bubble = "bubble"
    case StackColumn = "stacked_column"
    case StackArea = "stacked_line"
    case StackBar = "stacked_bar"
    case Table = "table"
    case Suggestion = "suggestion"
    case Safetynet = "safetynet"
    static func withLabel(_ str: String) -> ChatComponentType {
        return self.allCases.first {
            "\($0.description)" == str
        } ?? Introduction
    }
    var description: String {
        return self.rawValue
    }
}
