//
//  WebViewFunctions.swift
//  chata
//
//  Created by Vicente Rincon on 02/04/20.
//

import Foundation
func getHTMLHeader(triType: Bool = false) -> String {
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <title></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1.0, user-scalable=no">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="https://unpkg.com/sticky-table-headers"></script>
    \(getHTMLCharts(triType: triType))
    <link href=“https://fonts.googleapis.com/css?family=Titillium+Web” rel=“stylesheet”>
    <meta http-equiv='cache-control' content='no-cache'>
    <meta http-equiv='expires' content='0'>
    <meta http-equiv='pragma' content='no-cache'>
    </head>
    <body>
    \(getHTMLStyle())
    <div class="splitView">
    <div id='container' class='container'></div>
    """
}
func getHTMLCharts(triType: Bool) -> String {
    let headsBi = """
        <script src="https://code.highcharts.com/highcharts.js"></script>
    """
    let headsTri = """
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/highcharts-more.js"></script>
        <script src="https://code.highcharts.com/modules/heatmap.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
    """
    let finalhead = triType ? headsTri : headsBi
    return """
        \(finalhead)
    """
}
func getHTMLStyle() -> String {
    let style = """
    <style type="text/css">
        body, table, th{
            background: \(chataDrawerWebViewBackground)!important;
            color: \(chataDrawerWebViewText)!important;
        }
        table {
            padding-top: 0px!important;
        }
        th {
            position: sticky;
            top: 0px;
            z-index: 10;
            padding: 10px 3px 5px 3px;
        }
        table {
            display: table;
            min-width: 100%;
            white-space: nowrap;
            border-collapse: separate;
            border-spacing: 0px!important;
            border-color: grey;
        }
        table {
            font-size: 12px;
        }
        tr td:first-child {
            text-align: center;
        }
        td {
            padding: 3px;
            text-align: center!important;
        }
        td, th {
          font-size: 16px;
        }
        .green{
            color: #2ecc40;
        }
        .red {
            color: red;
        }
        .highcharts-credits,.highcharts-button-symbol, .highcharts-exporting-group {
            display: none;
        }
        .highcharts-background{
            fill: \(chataDrawerWebViewBackground)!important;
        }
        .splitView{
            position: relative;
        }
    </style>
    """
    return style
}
func getHTMLFooter(rows: [[String]], columns: [String], types: [ChatTableColumnType], drills: [String], type: String, split: Bool = false) -> String {
    var scriptJS = ""
    if rows.count > 0 && columns.count > 0 {
        scriptJS += getChartFooter(rows: rows, columns: columns, types: types, drills: drills, mainType: type)
        scriptJS += getFooterScript()
    }
    return """
    </div>
    <script>
    \(scriptJS)
    hideAll();
    function hideAll(){
        $('table').css({ "width": "100%", "position": "relative","height":"90%", "z-index": "0" });
        $( "#idTableBasic, #idTableDataPivot, #idTableDatePivot, #container" ).hide();
        if (type == "#idTableBasic" || type == "#idTableDataPivot" || type == "#idTableDatePivot"){
            $(""+type+"").show()
        } else{
            $("#container").show()
            changeGraphic(type);
            if (\(split)){
                $( "#idTableBasic").show()
            }
        }
    }
    function hideTables(idHide, idShow, type2) {
        $( idShow ).show(0);
        $( idHide ).hide("slow");
        //$( idShow ).show("slow");
        type = type2;
        changeGraphic(type2);
    }
    </script>
    </body>
    </html>
    """
}
func getChartFooter(rows: [[String]], columns: [String], types: [ChatTableColumnType], drills: [String], mainType: String = "idTableBasic") -> String {
    let triType = columns.count  == 3
    let dataChartBi = triType ? [] : rows.map { (row) -> [Any] in
        let name = row[0]
        let mount = Double(row[1]) ?? 0.0
        return [name, mount]
    }
    let dataChartLine = rows.map { (row) -> Double in
        let mount = Double(row[1]) ?? 0.0
        return mount
    }
    let catX = rows.map { (row) -> String in
        let name = row[0]
        return name
    }
    var categoriesX: [String] = []
    var categoriesY: [String] = []
    var drillTableY: [String] = []
    var drillY: [String] = []
    var stacked: [[Double]] = []
    let datachartTri = triType ? rows.map { (column) -> [Any] in
        drillTableY.append(column[1])
        let data1 = column[0]
        let data2 = column[1].toDate()
        let data3 = Double(column[2]) ?? 0.0
        if categoriesX.firstIndex(of: data1) == nil {
            categoriesX.append(data1)
        }
        if categoriesY.firstIndex(of: data2) == nil {
            categoriesY.append(data2)
            drillY.append(column[1])
            stacked.append([])
        }
        let locX = categoriesX.firstIndex(of: data1) ?? 0
        let locY = categoriesY.firstIndex(of: data2) ?? 0
        stacked[locY].append(data3)
        return [locX, locY, data3]
    } : []
    var dataChartLineTri = triType ? categoriesY.enumerated().map({ (index, element) -> [String: Any] in
        var data: [String: Any] = [:]
        data["name"] = element
        data["data"] = stacked[index]//dataStackedColumn[i]
        return data
    }) : []
    let contrast = triType ? supportContrast(columns: types) : false
    if contrast {
        dataChartLineTri = []
        for (index, column) in columns.enumerated(){
            let idx = index + 1
            if index < 2 {
                var data: [String: Any] = [:]
                data["name"] = column
                data["data"] = rows.map({ (row) -> Double in
                    return Double(row[idx]) ?? 0.0
                })
                dataChartLineTri.append(data)
            }
        }
        categoriesX = rows.map({ (row) -> String in
            return row[0].toDate()
        })
    }
    let catFinaY: [Any] = triType ? categoriesY : dataChartLine
    let stringChartLine = arrayDictionaryToJson(json: dataChartLineTri)
    let dataChartLineFinal: String = triType ? stringChartLine : "\(dataChartLine)"
    return """
        var type = '\(mainType)';
        var xAxis = '\(columns[0])';
        var yAxis = '\(columns[1])';
        var dataChartBi = \(dataChartBi);
        var datachartTri = \(datachartTri);
        var dataChartLine = \(dataChartLineFinal);
    var categoriesX = \(triType ? categoriesX : catX);
    var categoriesY = \(catFinaY);
        var drillX = [];
        var drillTableY = \(drillTableY);
        var drillSpecial = \(drills);
        var drillY = \(drillY);
        var colorAxis = "\(chataDrawerWebViewText)";
        var colorFill = "\(chataDrawerWebViewBackground)";
    var color1 = "\(DataConfig.themeConfigObj.chartColors[0])";
    """
}
func tableString(dataTable: [[String]], dataColumn: [String], idTable: String, columnsType: [ChatTableColumnType], datePivot: Bool = false) -> String {
    let star = "<table id='\(idTable)'>"
    var body = ""
    let end = "</table>"
    if dataColumn.count > 0 {
        body = "<thead><tr>"
        for column in dataColumn {
            body += "<th>\(column)</th>"
        }
        body += "</tr></thead><tbody>"
        for row in dataTable {
            body += "<tr>"
            for (index, column) in row.enumerated() {
                let finalColumn = datePivot ? column : column.getTypeColumn(type: columnsType[index])
                body += "<td>\(finalColumn)</td>"
            }
            body += "</tr>"
        }
        body+="</tbody>"
    }
    return star + body + end
}
func arrayDictionaryToJson(json: [[String: Any]]) -> String {
    do {
        let json2 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: json2, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    } catch {
        print("problema con diccionario: \(String(describing: error))")
        return ""
    }
}
