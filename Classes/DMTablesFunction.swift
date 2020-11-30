//
//  TablesFunction.swift
//  chata
//
//  Created by Vicente Rincon on 08/04/20.
//

import Foundation
func getDatePivot(rows: [[String]], columnsT: [ChatTableColumnType]) -> [[String]] {
    var datePivot: [[String]] = [[""]]
    var infoPivot: DataPivotModel = getDataPivot(rows: rows, columnsT: columnsT)
    let yearsOrder = infoPivot.years.sorted(by: <)
    infoPivot.months = infoPivot.months.sorted(by: <)
    var filterMonth: [String] = []
    for mon in infoPivot.months {
        filterMonth.append(mon.toMonth())
    }
    infoPivot.months = filterMonth
    datePivot[0] += infoPivot.years
    if infoPivot.one365Pivot.count > 364 {
        infoPivot.one365Pivot.sort {$0.year < $1.year}
        infoPivot.one365Pivot.sort {$0.month < $1.month}
        datePivot += getAllDaysPivot(infoPivot: infoPivot, yearsOrder: yearsOrder)
    } else {
        datePivot += getMonthsPivot(infoPivot: infoPivot, yearsOrder: yearsOrder)
    }
    return datePivot
}
func getMonthsPivot(infoPivot: DataPivotModel, yearsOrder: [String]) -> [[String]] {
    var datePivot: [[String]] = [[""]]
    if infoPivot.months.count == 1 {
        datePivot += infoPivot.oneMonth
    } else {
        for (index, month) in infoPivot.months.enumerated() {
            datePivot.append([month])
            for year in yearsOrder {
                var total: Double = 0.0
                var time2 = ""
                for pivot in infoPivot.datePivotTable {
                    let valid1 = pivot.contains(where: {
                        $0.range(of: year, options: .caseInsensitive) != nil
                    })
                    let valid2 = pivot.contains(where: {
                        $0.range(of: month, options: .caseInsensitive) != nil
                    })
                    if valid1 && valid2 {
                        let num = pivot[2]
                        let totalD = Double(num) ?? 0.0
                        total += totalD
                        if time2 == ""{
                            time2 = pivot[3]
                        }
                    }
                }
                let final = total == 0.0 ? "" : String(total).toMoney()
                datePivot[index+1].append("<span class='selectData' id='\(time2)'> \(final) </span>")
            }
        }
    }
    return datePivot
}
func getAllDaysPivot(infoPivot: DataPivotModel, yearsOrder: [String]) -> [[String]] {
    var datePivot: [[String]] = [[""]]
    var index = 0
    var suma = 0.0
    var lastDate = ""
    var lastYear = ""
    infoPivot.one365Pivot.forEach({ (element) in
        let dateM = element.month.components(separatedBy: ".")
        let monthM = dateM[0].toMonth()
        let dayM = dateM[1]
        let time2 = element.timestamp
        let year = element.year
        if lastDate == "\(monthM) \(dayM)" && lastDate != ""{
            if lastYear == year {
                suma +=  Double(element.mount) ?? 0.0
            } else {
                suma = Double(element.mount) ?? 0.0
                lastYear = year
            }
            let pos = yearsOrder.firstIndex(of: year) ?? 0
            let final = String(suma).toMoney()
            datePivot[index][pos+1] = final
        } else {
            index += 1
            lastDate = "\(monthM) \(dayM)"
            suma = Double(element.mount) ?? 0.0
            let final = suma == 0.0 ? "" : String(suma).toMoney()
            var test: [String] = []
            test.append(lastDate)
            for yearO in yearsOrder {
                if yearO == year {
                    test.append("<span class='selectData' id='\(String(describing: time2!))'> \(final) </span>")
                } else {
                    test.append("-")
                }
            }
            datePivot.append(test)
        }
        lastYear = year
    })
    return datePivot
}
func getDataPivot(rows: [[String]], columnsT: [ChatTableColumnType]) -> DataPivotModel {
    var datePivotTable: [[String]] = []
    var years: [String] = []
    var months: [String] = []
    var oneMonth: [[String]] = [[""]]
    var one365Pivot: [DatePivotModal] = []
    var dateStringActive = false
    var position = columnsT.firstIndex(of: .date) ?? -1
    let positionDolar = columnsT.firstIndex(of: .dollar) ?? -1
    if position == -1 {
        position = columnsT.firstIndex(of: .dateString) ?? -1
        dateStringActive = true
    }
    position = position == -1 ? columnsT.firstIndex(of: .dateString) ?? -1 : position
    if position != -1 && positionDolar != -1 {
        for rowM in rows {
            let date = rowM[position]
            if !dateStringActive {
                let test = Date(timeIntervalSince1970: TimeInterval(date)!)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMC-5")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: test)
                
                dateFormatter.dateFormat = "MMMM"
                let month = dateFormatter.string(from: test)
                dateFormatter.dateFormat = "MM"
                let monthNum = dateFormatter.string(from: test)
                datePivotTable.append([month, year, rowM[positionDolar], date])
                dateFormatter.dateFormat = "MMMM dd"
                let monthDay = dateFormatter.string(from: test)
                dateFormatter.dateFormat = "MM.dd"
                let monthYear = dateFormatter.string(from: test)
                let one365Pivot1 = DatePivotModal(month: monthYear, year: year, mount: rowM[positionDolar], timestamp: date)
                one365Pivot.append(one365Pivot1)
                let str = "<span class='selectData' id='\(String(describing: date))'> \(String(rowM[positionDolar]).toMoney()) </span>"
                oneMonth.append([monthDay, str])
                let itemExists = years.contains(where: {
                    $0.range(of: year, options: .caseInsensitive) != nil
                })
                if !itemExists {
                    years.append(year)
                }
                let monthExists = months.contains(where: {
                    $0.range(of: monthNum, options: .caseInsensitive) != nil
                })
                if !monthExists {
                    months.append(monthNum)
                }
            } else {
                let separate = date.components(separatedBy: "-")
                let monthNumber = separate.count > 1 ? separate[1] : ""
                let year = separate.count > 0 ? separate[0] : ""
                let month = String(monthNumber.toMonth().prefix(3))
                datePivotTable.append([month, year, rowM[positionDolar], date])
                let str = "<span class='selectData' id='\(String(describing: date))'> \(String(rowM[positionDolar]).toMoney()) </span>"
                oneMonth.append(["\(month).\(year)", str])
                let itemExists = years.contains(where: {
                    $0.range(of: year, options: .caseInsensitive) != nil
                })
                if !itemExists {
                    years.append(year)
                }
                let monthExists = months.contains(where: {
                    $0.range(of: monthNumber, options: .caseInsensitive) != nil
                })
                if !monthExists {
                    months.append(monthNumber)
                }
                /*
                let one365Pivot1 = DatePivotModal(month: monthYear, year: year, mount: rowM[positionDolar], timestamp: date)
                one365Pivot.append(one365Pivot1)
                
                if !itemExists {
                    years.append(year)
                }
                if !monthExists {
                    months.append(monthNum)
                }*/
            }
            
        }
    }
    let data = DataPivotModel(datePivotTable: datePivotTable,
                              years: years, months: months,
                              oneMonth: oneMonth,
                              one365Pivot: one365Pivot)
    return data
}
func getDataPivotColumn(rows: [[String]], type: ChatTableColumnType = .dollar) -> ([[String]], [String]) {
    var categoriesX: [String] = []
    var categoriesY: [String] = []
    var totalSum: [DataPivotRow] = []
    var totalDate: [[Any]] = []
    for row in rows
    {
        let data1 = row[1]
        let data2 = row[0]
        let data3 = Double(row[2]) ?? 0
        if categoriesX.firstIndex(of: data1) == nil {
            categoriesX.append(data1)
        }
        if categoriesY.firstIndex(of: data2) == nil {
            categoriesY.append(data2)
            totalDate.append([])
        }
        let locX = categoriesX.firstIndex(of: data1) ?? 0
        let locY = categoriesY.firstIndex(of: data2) ?? 0
        totalDate[locY].append(data3)
        let test = DataPivotRow(posX: locX, posY: locY, value: data3)
        totalSum.append(test)
    }
    var final: [[String]] = []
    var validPivot = false
    for (indexY, cat) in categoriesX.enumerated(){
        var finalB = [cat]
        for (indexX, _) in categoriesY.enumerated() {
            let position = totalSum.firstIndex(where: {
                $0.posX == indexX && $0.posY == indexY
            })
            if position != nil {
                validPivot = position != 0
                let valueFinal = type == .dollar ? "\(totalSum[position!].value)".toMoney() : "\(totalSum[position!].value)"
                finalB.append(valueFinal)
            } else {
                let valueDefault = type == .dollar ? "$0" : "0"
                finalB.append(valueDefault)
            }
        }
        final.append(finalB)
        //sumas.append(test)
    }
    var header = [""]
    var headerFree: [String] = []
    for catY in categoriesY {
        header.append(catY)
        headerFree.append(catY)
    }
    final.insert(header, at: 0)
    let finalTotal = validPivot ? final : []
    return (finalTotal, headerFree)
}
struct DataPivotModel {
    var datePivotTable: [[String]] = []
    var years: [String] = []
    var months: [String] = []
    var oneMonth: [[String]] = [[""]]
    var one365Pivot: [DatePivotModal] = []
}
struct DatePivotModal {
    var month: String
    var year: String
    var mount: String
    var timestamp: String? = ""
    init(month: String, year: String, mount: String, timestamp: String) {
        self.month = month
        self.year = year
        self.mount = mount
        self.timestamp = timestamp
    }
}
