//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/03/22.
//

import Foundation
import SwiftUI
struct ComponentInfoModel {
    var chartImages: String?
    //var columns: [String]
    var displayType: String
    var interpretation: String
    var limitRowNum: Int
    var queryID: String
    var rowLimit: Int
    var rows: [[Any]]
    var sql: [String]
    var text: String
}
extension ComponentInfoModel: Decodable{
    enum CodingKeys: String, CodingKey{
        case chartImages = "chart_images"
        case columns = "columns"
        case displayType = "display_type"
        case interpretation = "interpretation"
        case limitRowNum = "limit_row_num"
        case queryID = "query_id"
        case rowLimit = "row_limit"
        case rows = "rows"
        case sql = "sql"
        case text = "text"
    }
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chartImages = try container.decodeIfPresent(String.self, forKey: .chartImages) ?? ""
        self.displayType = try container.decodeIfPresent(String.self, forKey: .displayType) ?? ""
        self.interpretation = try container.decodeIfPresent(String.self, forKey: .interpretation) ?? ""
        self.limitRowNum = try container.decodeIfPresent(Int.self, forKey: .limitRowNum) ?? 0
        self.queryID = try container.decodeIfPresent(String.self, forKey: .queryID) ?? ""
        self.rowLimit = try container.decodeIfPresent(Int.self, forKey: .rowLimit) ?? 0
        self.rows = []
        self.sql = try container.decodeIfPresent([String].self, forKey: .sql) ?? []
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        //self.columns = try container.decodeIfPresent([String].self, forKey: .columns) ?? []
    }
}
