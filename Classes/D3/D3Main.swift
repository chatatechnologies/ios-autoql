//
//  D3Main.swift
//  chata
//
//  Created by Vicente Rincon on 06/01/22.
//

import Foundation
func generateBiDatad3(rows: [[String]], columns: [ChatTableColumn]) -> (String, [String], Int){
    //print(rows)
    //print(columns)
    var finalData: [[String:Any]] = []
    var formatDate = ""
    var dateNumber:Bool = false
    for column in columns {
        if column.type == ChatTableColumnType.date{
            dateNumber = true
        }
        if column.type == ChatTableColumnType.date
            || column.type == ChatTableColumnType.dateString{
            formatDate = column.formatDate
            break
        }
    }
    rows.forEach { row in
        var dictTemp: [String: Any]  = [:]
        row.enumerated().forEach { (index, value) in
            let nameDict = index == 0 ? "name" : "value"
            if nameDict == "value" {
                dictTemp[nameDict] = Double(value) ?? 0.0
            } else {
                dictTemp[nameDict] = value
            }
            
        }
        finalData.append(dictTemp)
    }
    var sortedArray = finalData.sorted { $0["name"] as? String ?? "" < $1["name"] as? String ?? "" }
    var catX: [String] = []
    print(sortedArray)
    var columnsD3: [String] = []
    sortedArray.enumerated().forEach { (index, dict) in
        let date: String = sortedArray[index]["name"] as? String ?? ""
        catX.append(date)
        var finalDate = ""
        if dateNumber{
            finalDate = date.toDate(true)
        } else{
            finalDate = date.toDate2(format: formatDate)
        }
        sortedArray[index]["name"] = finalDate
        if columnsD3.firstIndex(of: finalDate) == nil{
            columnsD3.append(finalDate)
        }
        
    }
    let jsonString = arrayDictionaryToJson(json: sortedArray)
    return (jsonString, catX, columnsD3.count)
}
