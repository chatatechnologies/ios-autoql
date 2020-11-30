//
//  ChataServices.swift
//  chata
//
//  Created by Vicente Rincon on 11/03/20.
//

import Foundation
typealias CompletionArrString = (_ response: [String]) -> Void
typealias CompletionChatComponentModel = (_ response: ChatComponentModel) -> Void
typealias CompletionChatQueryBuilderModel = (_ response: [QueryBuilderModel]) -> Void
typealias CompletionSecondData = (_ response: String) -> Void
typealias CompletionDashboards = (_ response: [DashboardList]) -> Void
typealias CompletionQueryTips = (_ response: QTModel) -> Void
typealias CompletionSuggestions = (_ response: [String]) -> Void
typealias CompletionNotifications = (_ response: [NotificationItemModel]) -> Void
public typealias CompletionChatSuccess = (_ response: Bool) -> Void
typealias CompletionChatSafetynet = (_ response: [ChatFullSuggestion]) -> Void
class ChataServices {
    static let instance = ChataServices()
    private var projectID = ""
    private var jwt = ""
    private var username = ""
    private var isLoggin: Bool = false
    func getJwt() -> String {
        return ChataServices.instance.jwt
    }
    func setProjectID(projectID: String){
        ChataServices.instance.projectID = projectID
    }
    func setJWT(jwt: String) {
        ChataServices.instance.jwt = jwt
    }
    func getUser() -> Bool {
        return ChataServices.instance.isLoggin
    }
    func getProjectID() -> String {
        return ChataServices.instance.projectID
    }
    func setLogin(active: Bool) {
        ChataServices.instance.isLoggin = active
    }
    func logout(completion: @escaping CompletionChatSuccess){
        clearData()
        completion(true)
    }
    func clearData(){
        LOGIN = false
        DataConfig.authenticationObj.token = ""
        ChataServices.instance.jwt = ""
        DataConfig.authenticationObj.apiKey = ""
        ChataServices.instance.isLoggin = false
        ChataServices.instance.projectID = ""
        ChataServices.instance.username = ""
        wsUrlDynamic = ""
        DataConfig.authenticationObj.domain = ""
    }
    func login(parameters: [String: Any] = [:], completion: @escaping CompletionChatSuccess){
        let user: String = parameters["username"] as? String ?? ""
        let body: [String: Any] = [
            "username": user,
            "password": parameters["password"] ?? ""
        ]
        let urlRequest = wsLogin
        httpRequest(urlRequest, "POST", body, content: "application/x-www-form-urlencoded", resultText: true) { (response) in
            self.logout { (success) in
                let result = response["result"] as? String ?? ""
                if result != "The username/password incorrect"{
                    DataConfig.authenticationObj.apiKey = parameters["apiKey"] as? String ?? ""
                    DataConfig.authenticationObj.token = result
                    ChataServices.instance.username = user
                    completion(result != "")
                } else {
                    completion(false)
                }
                
            }
        }
    }
    func getJWTResponse(parameters: [String: Any], completion: @escaping CompletionChatSuccess) {
        let mail = parameters["userID"] ?? ""
        let project_id = parameters["projectID"] ?? ""
        let url = "\(wsJwt)\(mail)&project_id=\(project_id)"
        httpRequest(url, resultText: true) { (response) in
            let result = response["result"] as? String ?? ""
            ChataServices.instance.jwt = result
            DataConfig.authenticationObj.domain = (parameters["domain"] as? String ?? "")
            wsUrlDynamic = DataConfig.authenticationObj.domain
            ChataServices.instance.projectID = parameters["projectID"] as? String ?? ""
            self.getValidData { (success) in
                if success {
                    let loginSuccess = result != "" && result.count > 30
                    ChataServices.instance.isLoggin = loginSuccess
                    completion(loginSuccess)
                } else {
                    self.clearData()
                    completion(success)
                }
            }
        }
    }
    func getQueries(query: String, completion: @escaping CompletionArrString){
        let handleQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlRequest = "\(wsAutocomplete)\(handleQuery)&projectid=1"
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query/autocomplete?text=\(handleQuery)&key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = !DataConfig.demo ? urlRequestUser : urlRequest
        httpRequest(urlFinal) { (response) in
            let responseFinal: [String: Any] = !DataConfig.demo ? response["data"] as? [String: Any] ?? [:] : response
            let matches = responseFinal["matches"] as? [String] ?? []
            completion(matches)
        }
    }
    func getSafetynet(query: String, completion: @escaping CompletionChatSafetynet){
        let handleQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlRequest = !DataConfig.demo
            ? "\(wsUrlDynamic)/autoql/api/v1/query/validate?text=\(handleQuery)&key=\(DataConfig.authenticationObj.apiKey)"
            : "\(wsSafetynet)\(handleQuery)&projectId=\(projectID)"
        httpRequest(urlRequest) { (response) in
            if DataConfig.demo {
                completion([])
            } else {
                let data = response["data"] as? [String: Any] ?? [:]
                let replacements = data["replacements"] as? [[String:Any]] ?? []
                let final: [ChatFullSuggestion] = replacements.map { (suggestion) -> ChatFullSuggestion in
                    let start = suggestion["start"] as? Int ?? 0
                    let end = suggestion["end"] as? Int ?? 0
                    let suggs = suggestion["suggestions"] as? [[String: Any]] ?? []
                    let suggestion: [ChataFullSuggestionItem] = suggs.map { (sugg) -> ChataFullSuggestionItem in
                        let text = sugg["text"] as? String ?? ""
                        let valueLabel = sugg["value_label"] as? String ?? ""
                        return ChataFullSuggestionItem(valueLabel: valueLabel, text: text)
                    }
                    let model = ChatFullSuggestion(suggestionList: suggestion, start: start, end: end)
                    return model
                }
                completion(final)
            }
        }
    }
    func getDataChat(query: String, type: String = "", queryOutput: Bool = false, completion: @escaping CompletionChatComponentModel){
        
        let body: [String: Any] =
            [
                "text": query,
                "source": !queryOutput ? "data_messenger.user" : "user",
                "test": true,
                "translation": "include"
            ]
        let urlRequest = wsQuery
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query?key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = !DataConfig.demo ? urlRequestUser : urlRequest
        httpRequest(urlFinal, "POST", body) { (response) in
            let referenceId = response["reference_id"] as? String ?? ""
            var finalComponent = self.getDataComponent(response: response,
                                                       type: type, query: query,
                                                       referenceID: referenceId)
            if referenceId == "1.1.211" {
                let msg = response["message"] as? String ?? ""
                finalComponent.type = .Introduction
                finalComponent.user = false
                finalComponent.text = msg
            }
            completion(finalComponent)
        }
    }
    func getSuggestionsQueries(query: String, completion: @escaping CompletionSuggestions) {
        let finalQuery = query.replace(target: " ", withString: ",")
        let finalUrl = "\(wsUrlDynamic)/autoql/api/v1/query/related-queries?key=\(DataConfig.authenticationObj.apiKey)&search=\(finalQuery)&scope=narrow"
        httpRequest(finalUrl) { (response) in
            let data = response["data"] as? [String: Any] ?? [:]
            let items = data["items"] as? [String] ?? []
            completion(items)
        }
    }
    func getValidData(completion: @escaping CompletionChatSuccess) {
        let finalUrl = "\(wsUrlDynamic)/autoql/api/v1/query/related-queries?key=\(DataConfig.authenticationObj.apiKey)&search=test"
        httpRequest(finalUrl) { (response) in
            let result = response["result"] as? String ?? ""
            let msg = response["message"] as? String ?? result
            completion(msg == "" || msg == "Success")
        }
    }
    func reportProblem(queryID: String, problemType: String, completion: @escaping CompletionChatSuccess) {
        let url = "\(wsUrlDynamic)/autoql/api/v1/query/\(queryID)?key=\(DataConfig.authenticationObj.apiKey)"
        let body: [String: Any] = [
            "is_correct": false,
            "message": problemType
        ]
        httpRequest(url, "PUT", body) { (response) in
            let referenceID = response["reference_id"] as? String ?? ""
            completion(referenceID == "1.1.200")
        }
    }
    func getDataChatDrillDown(obj: String, idQuery: String, name: String, completion: @escaping CompletionChatComponentModel){
        let guion = obj.contains("_")
        var group_bys: [[String: Any]] = []
        if guion{
            let values = obj.split(separator: "_")
            let keys = name.split(separator: "º")
            if keys.count > 1 && values.count > 1{
                let valueOne = String(values[0]).toStrDate()
                let valueTwo = String(values[1]).toStrDate()
                group_bys = [[
                        "name": String(keys[1]),
                        "value": valueTwo
                    ],
                    [
                        "name": String(keys[0]),
                        "value": valueOne
                    ]
                ]
            }
        } else {
            var dateFinal = String(obj)
            dateFinal = name.contains("yyyy") ?  dateFinal.toStrDate() : dateFinal
            if name != ""{
                group_bys = [
                    [
                        "name" : name,
                        "value" : dateFinal
                    ]
                ]
            }
        }
        let body: [String: Any] = DataConfig.demo
            ?   [:]
            :   [
                    "columns": group_bys,
                    "test": true,
                    "translation": "include"
                ]
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query/\(idQuery)/drilldown?key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = !DataConfig.demo ? urlRequestUser : "\(wsQuery)/drilldown"
        httpRequest(urlFinal, "POST", body) { (response) in
            let finalComponent = self.getDataComponent(response: response, drilldown: true)
            completion(finalComponent)
        }
    }
    func getDataQueryBuilder(completion: @escaping CompletionChatQueryBuilderModel){
        let projectID = ChataServices.instance.getProjectID()
        let finalUrl = "\(wsQueryBuilder)\(DataConfig.authenticationObj.apiKey)&project_id=\(projectID)"
        httpRequest(finalUrl, integrator: true) { (response) in
            let items = response["items"] as? [[String: Any]] ?? []
            var qboptions: [QueryBuilderModel] = []
            items.forEach { (item) in
                let topic = item["topic"] as? String ?? ""
                let queries = item["queries"] as? [String] ?? []
                let qbOption = QueryBuilderModel(topic: topic, queries: queries)
                qboptions.append(qbOption)
            }
            completion(qboptions)
        }
    }
    func getDrillComponent(data: [[String]], columns: [ChatTableColumn]) -> ChatComponentModel {
        var newComponent = ChatComponentModel()
        let webviewS = genereteFinalWebView(
                                            type: "table",
                                            second: "",
                                            mainColumn: -1,
                                            rowsFinal: data,
                                            rowsFinalClean: data,
                                            columnsFinal: columns)
        let numRows = data.count > 0 ? data.count : 0
        let columnsFilter = columns.map { (column) -> ChatTableColumnType in
            return column.type
        }
        newComponent.webView = webviewS
        newComponent.type = .Table
        newComponent.biChart = validBiCharts(rows: data, columnsFinal: columns)
        newComponent.numRow = numRows
        newComponent.rowsClean = data
        newComponent.dataRows = data
        newComponent.columnsInfo = columns
        newComponent.columns = columnsFilter
        return newComponent
    }
    func validBiCharts(rows: [[String]], columnsFinal: [ChatTableColumn]) -> Bool {
        var valid = false
        rows.forEach { (row) in
            row.enumerated().forEach { (index, column) in
                if !valid && (columnsFinal[index].type == .dollar || columnsFinal[index].type == .quantity) {
                    /*let doubleFinal = Double(element as? String ?? "") ?? 0*/
                    if let intFinal = Int(column) {
                        if intFinal > 0 {
                            valid = true
                        }
                    }
                }
            }
        }
        return valid
    }
    func validType(rows: [[Any]], type: String) -> String {
        var finalType = type
        let triChartValid = triChartList(type: type)
        if rows.count > 0 {
            if triChartValid && rows[0].count > 3 {
                finalType = ""
            }
            if rows[0].count <= 1 {
                finalType = ""
            }
        }
        return finalType
    }
    func getDataComponent(response: [String: Any],
                          type: String = "",
                          split: Bool = false,
                          splitType: String = "",
                          query: String = "",
                          items: [String] = [],
                          drilldown: Bool = false,
                          position: Int = 0,
                          secondQuery: String = "",
                          mainColumn: Int = -1,
                          second: String = "",
                          referenceID: String = "") -> ChatComponentModel {
        var data = response["data"] as? [String: Any] ?? [:]
        let referenceID = response["reference_id"] as? String ?? ""
        if referenceID == "1.1.211" {
            data = [:]
        }
        let idQueryDefault = data["query_id"] as? String ?? UUID().uuidString
        var dataModel = ChatComponentModel(webView: "error",
                                           options: items,
                                           position: position,
                                           referenceID: referenceID)
        dataModel.idQuery = idQueryDefault
        if items.count > 0{
            dataModel.type = .Suggestion
        }
        let message = response["message"] as? String ?? "Uh oh.. It looks like you don't have access to this resource. Please double check that all required authentication fields are correct."
        dataModel.text = message
        if data.count > 0 && dataModel.text != "No Data Found" {
            let columns = data["columns"] as? [[String: Any]] ?? []
            let rows = data["rows"] as? [[Any]] ?? []
            let (columnsFinal, group) = getColumns(columns: columns)
            var typeD = type
            if group {
                if type == "" {
                    typeD = "column"
                    if rows.count > 0 {
                        if rows[0].count == 3 {
                            typeD = "stacked_column"
                        }
                    }
                }
            }
            let typeF = validType(rows: rows, type: typeD)
            let finalType = typeF == "" ? (data["display_type"] as? String ?? "") : typeF
            let idQuery = data["query_id"] as? String ?? UUID().uuidString
            var displayType: ChatComponentType = ChatComponentType.withLabel(finalType)
            var textFinal = ""
            var user = true
            var numRow = 20
            var biChart = false
            let positionColumn = getColumnPosition(columnsFinal: columnsFinal)
            let (rowsFinal, rowsFinalClean, validBiChart) = getRows(rows: rows, columnsFinal: columnsFinal)
            biChart = validBiChart
            let (finalUser, finalText, newDisplayType) = getFinalText(rows: rows, user: user, text: textFinal, displayType: displayType, columnsFinal: columnsFinal)
            user = finalUser
            textFinal = finalText
            displayType = newDisplayType
            numRow = rows.count
            let columnsF = columnsFinal.map { (element) -> String in
                return element.name
            }
            let suggestions: [String] = displayType == ChatComponentType.Suggestion ?
                rows.map{ (element) -> String in
                    return "\(element[0])"
            } : []
            
            var webView = ""
            let chartsBi = displayType == .Pie || displayType == .Bar || displayType == .Column || displayType == .Line
            let chartsTri = displayType == .Heatmap || displayType == .Bubble || displayType == .StackColumn || displayType == .StackBar || displayType == .StackArea
            let columsType = columnsFinal.map({ (element) -> ChatTableColumnType in
                return element.type
            })
            if columnsF.count == 0 && rows.count == 0{
                displayType = .Introduction
                user = false
                textFinal = message
            }
            if displayType == .Webview || displayType == .Table || chartsBi || chartsTri{
                //let typeInit = typeF.replace(target: "stacked_", withString: "")
                let webviewS = genereteFinalWebView(
                                                    type: typeF,
                                                    second: second,
                                                    mainColumn: mainColumn,
                                                    rowsFinal: rowsFinal,
                                                    rowsFinalClean: rowsFinalClean,
                                                    columnsFinal: columnsFinal,
                                                    positionColumn: positionColumn)
                webView = webviewS
            } else {
                webView = "text"
            }
            if displayType == .Suggestion {
                if !DataConfig.autoQLConfigObj.enableQuerySuggestions{
                    displayType = .Introduction
                    textFinal = "Bad Query"
                    user = false
                }
            }
            dataModel =  ChatComponentModel(
                type: displayType,
                text: textFinal == "" ? query : textFinal,
                user: user,
                webView: webView,
                numRow: numRow,
                options: suggestions,
                dataRows: rowsFinal,
                colunms: columsType,
                idQuery: idQuery,
                columnsInfo: columnsFinal,
                drillDown: drilldown,
                position: position,
                biChart: biChart,
                rowsClean: rowsFinalClean,
                referenceID: referenceID,
                groupable: group
            )
        }
        return dataModel
    }
    func getColumnPosition(columnsFinal: [ChatTableColumn]) -> Int {
        var mainPos = -1
        for (index, columT) in columnsFinal.enumerated() {
            if columT.groupable && columT.type == .dateString{
                mainPos = index
                break
            }
        }
        return mainPos
        
    }
    func genereteFinalWebView(
                         type: String = "",
                         second: String = "",
                         mainColumn: Int = -1,
                         rowsFinal: [[String]],
                         rowsFinalClean: [[String]],
                         columnsFinal: [ChatTableColumn],
                         positionColumn: Int = 0) -> String {
        let columsType = columnsFinal.map({ (element) -> ChatTableColumnType in
            return element.type
        })
        let columnsF = columnsFinal.map { (element) -> String in
            return element.name
        }
        let existsDatePivot = supportPivot(columns: columsType)
        let supportTri = columnsFinal.count == 3
        var datePivotStr = ""
        var dataPivotStr = ""
        var tableBasicStr = ""
        var drills: [String] = []
        if existsDatePivot {
            var datePivot =  getDatePivot(rows: rowsFinalClean, columnsT: columsType)
            let columnsTemp = datePivot[0]
            datePivot.remove(at: 0)
            datePivotStr = tableString(dataTable: datePivot,
                                    dataColumn: columnsTemp,
                                    idTable: "idTableDatePivot",
                                    columns: columnsFinal,
                                    datePivot: true,
                                    positionColumn: positionColumn)
        }
        if supportTri {
            var (dataPivot, drill) = getDataPivotColumn(rows: rowsFinal, type: columsType[2])
            if !dataPivot.isEmpty{
                drills = drill
                let dataPivotColumnsTemp = dataPivot[0]
                var arrFinal: [String] = []
                dataPivot.forEach { (arr) in
                    let header = arr[0]
                    arrFinal.append(header)
                }
                dataPivot.remove(at: 0)
                dataPivotStr = tableString(
                    dataTable: dataPivot,
                    dataColumn: dataPivotColumnsTemp,
                    idTable: "idTableDataPivot",
                    columns: columnsFinal,
                    datePivot: true)
            } else {
                dataPivotStr = tableString(dataTable: rowsFinal,
                                        dataColumn: columnsF,
                                        idTable: "idTableDataPivot",
                                        columns: columnsFinal,
                                        datePivot: false,
                                        reorder:  true,
                                        cleanRow: rowsFinalClean)
            }
            
        }
        
        tableBasicStr = tableString(dataTable: rowsFinal,
                                dataColumn: columnsF,
                                idTable: "idTableBasic",
                                columns: columnsFinal,
                                datePivot: false,
                                reorder:  true,
                                cleanRow: rowsFinalClean
        )
        var typeFinal = type == "" || type == "data" ? "#idTableBasic" : type
        typeFinal = typeFinal == "table" ? "#idTableBasic" : typeFinal
        /*let dataPie = generateChart(rows: rowsFinal,
                                    columns: columnsF)*/
        //getPieChart(dataChart: dataPie)
        //generateChart(rows: rowsFinal,columns: columnsF)
        let webView = """
            \(getHTMLHeader(triType: columnsF.count == 3))
            \(datePivotStr)
            \(dataPivotStr)
            \(tableBasicStr)
        \(getHTMLFooter(rows: rowsFinal,
                        columns: columnsF,
                        types: columsType,
                        drills: drills,
                        type: typeFinal,
                        mainColumn: mainColumn,
                        second: second,
                        positionColumn: positionColumn
        ))
        """
        return webView
    }
    func getSplit(type: String, table: String = "") -> String {
        let wbSplit = "<div>SplitView</div>"
        if type == "table" {
            
        }
        return wbSplit
    }
    func getColumns(columns: [[String: Any]] ) -> ([ChatTableColumn], Bool) {
        var columnsFinal: [ChatTableColumn] = []
        var group = false
        for (_, column) in columns.enumerated() {
            let isVisible: Bool = !DataConfig.autoQLConfigObj.enableColumnVisibilityManager ? true : column["is_visible"] as? Bool ?? true
            let groupable: Bool = column["groupable"] as? Bool ?? false
            let name: String = !DataConfig.demo ? (column["display_name"] as? String ?? "") : (column["name"] as? String ?? "")
            let originalName = column["name"] as? String ?? ""
            let type: String = column["type"] as? String ?? ""
            let finalType = ChatTableColumnType.withLabel(type)
            var ffDate = ""
            if finalType == .dateString {
                let found1 = originalName.firstIndex(of: "'")
                let found2 = originalName.lastIndex(of: "'")
                let myRange = found1!..<found2!
                var finalStr = String(originalName[myRange])
                finalStr.removeFirst()
                ffDate = finalStr
            }
            if groupable {
                group = true
            }
            let column = ChatTableColumn(name: name,
                                         type: finalType,
                                         originalName: originalName,
                                         formatDate: ffDate,
                                         isVisible: isVisible,
                                         groupable: groupable)
            columnsFinal.append(column)
            
        }
        return (columnsFinal, group)
    }
    func getRows(rows: [[Any]], columnsFinal: [ChatTableColumn]) -> ([[String]], [[String]], Bool){
        var rowsFinal: [[String]] = []
        var validValue = false
        var rowsFinalClean: [[String]] = []
        for row in rows {
            var finalRow: [String] = []
            var finalRowClean: [String] = []
            row.enumerated().forEach { (index, element) in
                if columnsFinal[index].type == .dateString {
                    if columnsFinal.count > index {
                        let strDate = "\(element)"
                        finalRow.append(strDate.toDate2(format: columnsFinal[index].formatDate))
                        finalRowClean.append(strDate)
                    }
                } else {
                    finalRow.append("\(element)")
                    finalRowClean.append("\(element)")
                }
                if !validValue && (columnsFinal[index].type == .dollar || columnsFinal[index].type == .quantity) {
                    /*let doubleFinal = Double(element as? String ?? "") ?? 0*/
                    let intFinal = element as? Int ?? 0
                    let doubleFinal = element as? Double ?? 0.0
                    if intFinal != 0 || doubleFinal != 0.0 {
                        validValue = true
                    }
                }
            }
            rowsFinalClean.append(finalRowClean)
            rowsFinal.append(finalRow)
        }
        validValue = rows.count > 1 ? validValue : false
        return (rowsFinal, rowsFinalClean, validValue)
    }
    func getFinalText(rows: [[Any]],
                      user: Bool,
                      text: String,
                      displayType: ChatComponentType,
                      columnsFinal: [ChatTableColumn]) -> (Bool, String, ChatComponentType) {
        var finalText = text
        var newDisplayType = displayType
        var finalUser = user
        if rows.count == 1{
            if rows[0].count == 1{
                newDisplayType = .Introduction
                if columnsFinal[0].type == .dollar {
                    finalText = "\(rows[0][0] )".toMoney()
                }
                else {
                    finalText = "\(rows[0][0] )"
                }
                finalUser = false
            }
        }
        return (finalUser, finalText, newDisplayType)
    }
}
struct DashboardList {
    var createdAt: String
    var data: [DashboardModel]
    var id: Int
    var name: String
    var updatedAt: String
    init(createdAt: String = "",
         data: [DashboardModel] = [],
         id: Int = 0,
         name: String = "",
         updatedAt: String = "") {
        self.createdAt = createdAt
        self.data = data
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
    }
}
struct SubDashboardModel {
    var displayType: String
    var webview: String
    var text: String
    var type: ChatComponentType
    var idQuery: String
    var loading: Int
    var items: [String]
    var columnsInfo: [ChatTableColumn]
    var rowsClean: [[String]]
    init(
        displayType: String = "",
        webview: String = "",
        text: String = "",
        type: ChatComponentType = .Introduction,
        idQuery: String = "",
        loading: Int = 0,
        items: [String] = [],
        columnsInfo: [ChatTableColumn] = [],
        rowsClean: [[String]] = []
    ) {
        self.displayType = displayType
        self.webview = webview
        self.text = text
        self.type = type
        self.idQuery = idQuery
        self.loading = loading
        self.items = items
        self.columnsInfo = columnsInfo
        self.rowsClean = rowsClean
    }
}
struct DashboardModel {
    var minW: Int
    var staticVar: Int
    var maxH: Int
    var minH: Int
    var displayType: String
    var posX: Int
    var posY: Int
    var identify: Int
    var query: String
    var isNewTile: Int
    var title: String
    var key: String
    var moved: Int
    var posH: Int
    var posW: Int
    var webview: String
    var cleanRows: [[String]]
    var type: ChatComponentType
    var text: String
    var splitView: Bool
    var secondDisplayType: String
    var idQuery: String
    var columnsInfo: [ChatTableColumn]
    var secondQuery: String
    var loading: Int
    var secondLoading: Int
    var items: [String]
    var subDashboardModel: SubDashboardModel
    var stringColumnIndex: Int
    var stringColumnIndexSecond: Int
    init(
        minW: Int = 0,
        staticVar: Int = 0,
        maxH: Int = 0,
        minH: Int = 0,
        displayType: String = "",
        posX: Int = 0,
        posY: Int = 0,
        identify: Int = 0,
        query: String = "",
        isNewTile: Int = 0,
        title: String = "",
        key: String = "",
        moved: Int = 0,
        posH: Int = 0,
        posW: Int = 0,
        webview: String = "",
        cleanRows: [[String]] = [],
        type: ChatComponentType = ChatComponentType.Introduction,
        text: String = "",
        splitView: Bool = false,
        secondDisplayType: String = "",
        idQuery: String = "",
        columnsInfo: [ChatTableColumn] = [],
        secondQuery: String = "",
        loading: Int = 0,
        secondLoading: Int = 0,
        items: [String] = [],
        subDashboardModel: SubDashboardModel = SubDashboardModel(),
        stringColumnIndex: Int = 0,
        stringColumnIndexSecond: Int = 0
    ) {
        self.minW = minW
        self.staticVar = staticVar
        self.maxH = maxH
        self.minH = minH
        self.displayType = displayType
        self.posX = posX
        self.posY = posY
        self.identify = identify
        self.query = query
        self.isNewTile = isNewTile
        self.title = title
        self.key = key
        self.moved = moved
        self.posH = posH
        self.posW = posW
        self.webview = webview
        self.cleanRows = cleanRows
        self.type = type
        self.text = text
        self.splitView = splitView
        self.secondDisplayType = secondDisplayType
        self.idQuery = idQuery
        self.columnsInfo = columnsInfo
        self.secondQuery = secondQuery
        self.loading = loading
        self.secondLoading = secondLoading
        self.items = items
        self.subDashboardModel = subDashboardModel
        self.stringColumnIndex = stringColumnIndex
        self.stringColumnIndexSecond = stringColumnIndexSecond
    }
}
struct DataPivotRow{
    var posX: Int
    var posY: Int
    var value: Double
}
struct dataResponse {
    var mainColumn: Int
    var data: [[String]]
    
}

