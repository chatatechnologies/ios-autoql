//
//  File.swift
//  
//
//  Created by Vicente Rincon on 18/03/22.
//

import Foundation
class TableViewHTML{
    static let instance = TableViewHTML()
    func getTable(_ info: ComponentInfoModel) -> String{
        let htmlTable = """
            \(getTableHeader(info))
            \(getTableBody(info))
        """
        return htmlTable
    }
    private func getTableHeader(_ info: ComponentInfoModel) -> String{
        let dispaysNamesColumns = info.columns.compactMap { column in
            column.displayName
        }
        var header = "<table id='table'><thead><tr>"
        for (index, column) in dispaysNamesColumns.enumerated() {
            let th = "<th>\(column)</th>"
            header += info.columns[index].isVisible ? th : ""
        }
        header += "</thead></tr>"
        return header
    }
    private func getTableBody(_ info: ComponentInfoModel) -> String{
        var body = "<tbody>"
        for row in info.rows {
            body += "<tr>"
            for (indexRow, column) in row.enumerated() {
                let td = "<td>\(column)</td>"
                body += info.columns[indexRow].isVisible ? td : ""
            }
            body += "</tr>"
        }
        body += "</tbody></table>"
        return body
    }
}

