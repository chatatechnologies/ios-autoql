//
//  ChataServices.swift
//  chata
//
//  Created by Vicente Rincon on 11/03/20.
//

import Foundation
typealias CompletionArrString = (_ response: [String]) -> Void
typealias CompletionChatComponentModel = (_ response: ChatComponentModel) -> Void
typealias CompletionSecondData = (_ response: String) -> Void
typealias CompletionDashboards = (_ response: [DashboardList]) -> Void
typealias CompletionSuggestions = (_ response: [String]) -> Void
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
    func getJWT(parameters: [String: Any], completion: @escaping CompletionChatSuccess) {
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
            
            //completion(matches)
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
    func getDataChat(query: String, completion: @escaping CompletionChatComponentModel){
        let body: [String: Any] = !DataConfig.demo
            ?   [
                    "text": query,
                    "source": "data_messenger.user",
                    "debug": true,
                    "test": true
                ]
            :   [
                    "text": query,
                    "source": "data_messenger",
                    "user_id": "demo",
                    "customer_id": "demo"
                ]
        let urlRequest = wsQuery
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query?key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = !DataConfig.demo ? urlRequestUser : urlRequest
        httpRequest(urlFinal, "POST", body) { (response) in
            //let responseFinal: [String: Any] = ChataServices.instance.isLoggin ? response["data"] as? [String: Any] ?? [:] : response
            let msg = response["message"] as? String ?? ""
            if msg == "I want to make sure I understood your query. Did you mean:"{
                self.getSuggestionsQueries(query: query) { (items) in
                    let finalComponent = self.getDataComponent(response: response, query: query, items: items)
                    completion(finalComponent)
                }
            } else {
                let finalComponent = self.getDataComponent(response: response, query: query)
                completion(finalComponent)
            }
            //completion(matches)
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
        //HAcer bien la validacion, ya que marca fail
        let finalUrl = "\(wsUrlDynamic)/autoql/api/v1/query/related-queries?key=\(DataConfig.authenticationObj.apiKey)&search=test"
        httpRequest(finalUrl) { (response) in
            let result = response["result"] as? String ?? ""
            let msg = response["message"] as? String ?? result
            completion(msg == "" || msg == "Success")
        }
    }
    func getDataChatDrillDown(obj: String, idQuery: String, name: String, completion: @escaping CompletionChatComponentModel){
        let guion = obj.contains("_")
        var group_bys: [[String: Any]] = []
        if guion{
            let values = obj.split(separator: "_")
            let keys = name.split(separator: "º")
            if keys.count > 1 && values.count > 1{
                var test = String(values[1])
                test = test.toStrDate()
                group_bys = [[
                        "name": String(keys[0]),
                        "value": String(values[0])
                    ],
                    [
                        "name": String(keys[1]),
                        "value": test
                    ]
                ]
            }
        } else {
            if name != ""{
                group_bys = [
                    [
                        "name" : name,
                        "value" : obj
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
        //let urlRequest = wsQuery
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query/\(idQuery)/drilldown?key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = !DataConfig.demo ? urlRequestUser : "\(wsQuery)/drilldown"
        httpRequest(urlFinal, "POST", body) { (response) in
            //let responseFinal: [String: Any] = ChataServices.instance.isLoggin ? response["data"] as? [String: Any] ?? [:] : response
            let finalComponent = self.getDataComponent(response: response, drilldown: true)
            completion(finalComponent)
            //completion(matches)
        }
    }
    func getDataSecondQuery(response: [String: Any], type: String = "") -> String {
        let data = response["data"] as? [String: Any] ?? [:]
        if data.count > 0 {
            let columns = data["columns"] as? [[String: Any]] ?? []
            let finalType = type == "" ? (data["display_type"] as? String ?? "") : type
            let displayType: ChatComponentType = ChatComponentType.withLabel(finalType)
            //let idQuery = data["query_id"] as? String ?? ""
            let rows = data["rows"] as? [[Any]] ?? []
            let columnsFinal = getColumns(columns: columns)
            let (rowsFinal, _) = getRows(rows: rows, columnsFinal: columnsFinal)
            let columnsF = columnsFinal.map { (element) -> String in
                return element.name
            }
            let chartsBi = displayType == .Pie || displayType == .Bar || displayType == .Column || displayType == .Line
            let chartsTri = displayType == .Heatmap || displayType == .Bubble || displayType == .StackColumn || displayType == .StackBar || displayType == .StackArea
            // hacer DAta
            if displayType == .Webview || displayType == .Table || chartsBi || chartsTri{
                /*let existsDatePivot = supportPivot(columns: columsType)
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
                                            datePivot: true)
                }
                if supportTri {
                    var (dataPivot, drill) = getDataPivotColumn(rows: rowsFinal)
                    drills = drill
                    let dataPivotColumnsTemp = dataPivot[0]
                    dataPivot.remove(at: 0)
                    dataPivotStr = tableString(
                        dataTable: dataPivot,
                        dataColumn: dataPivotColumnsTemp,
                        idTable: "idTableDataPivot",
                        columns: columnsFinal,
                        datePivot: true)
                }*/
                let tableBasicStr = tableString(dataTable: rowsFinal,
                                        dataColumn: columnsF,
                                        idTable: "idTableBasicSplit",
                                        columns: columnsFinal,
                                        datePivot: false)
                //let tableType = splitType == "table"
                return tableBasicStr
                //let typeFinal = type == "" ? "#idTableBasic" : type
                /*webView = """
                    \(getHTMLHeader(triType: columnsF.count == 3))
                    \(datePivotStr)
                    \(dataPivotStr)
                    \(tableBasicStr)
                    \(split ? secondQuery : "")
                \(getHTMLFooter(rows: rowsFinal, columns: columnsF, types: columsType, drills: drills, type: typeFinal))
                """*/

            }
        }
        return "<p>Erro in Second Split</p>"
    }
    func getDataComponent(response: [String: Any],
                          type: String = "",
                          split: Bool = false,
                          splitType: String = "",
                          query: String = "",
                          items: [String] = [],
                          drilldown: Bool = false,
                          position: Int = 0,
                          secondQuery: String = "") -> ChatComponentModel {
        let data = response["data"] as? [String: Any] ?? [:]
        var dataModel = ChatComponentModel(webView: "error", options: items, position: position)
        if items.count > 0{
            dataModel.type = .Suggestion
        }
        let message = response["message"] as? String ?? "Uh oh.. It looks like you don't have access to this resource. Please double check that all the required authentication fields are provided."
        dataModel.text = message
        if data.count > 0 && dataModel.text != "No Data Found" {
            let columns = data["columns"] as? [[String: Any]] ?? []
            let finalType = type == "" ? (data["display_type"] as? String ?? "") : type
            var displayType: ChatComponentType = ChatComponentType.withLabel(finalType)
            let idQuery = data["query_id"] as? String ?? ""
            let rows = data["rows"] as? [[Any]] ?? []
            let columnsFinal = getColumns(columns: columns)
            var textFinal = ""
            var user = true
            var numRow = 20
            let (rowsFinal, rowsFinalClean) = getRows(rows: rows, columnsFinal: columnsFinal)
            if rows.count == 1{
                if rows[0].count == 1{
                    displayType = .Introduction
                    textFinal = "\(rows[0][0] )".toMoney()
                    user = false
                }
            }
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
                textFinal = "Uh oh.. It looks like you don't have access to this resource. Please double check that all the required authentication fields are provided."
            }
            if displayType == .Webview || displayType == .Table || chartsBi || chartsTri{
                
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
                                            datePivot: true)
                }
                if supportTri {
                    var (dataPivot, drill) = getDataPivotColumn(rows: rowsFinal)
                    drills = drill
                    let dataPivotColumnsTemp = dataPivot[0]
                    dataPivot.remove(at: 0)
                    dataPivotStr = tableString(
                        dataTable: dataPivot,
                        dataColumn: dataPivotColumnsTemp,
                        idTable: "idTableDataPivot",
                        columns: columnsFinal,
                        datePivot: true)
                }
                tableBasicStr = tableString(dataTable: rowsFinal,
                                        dataColumn: columnsF,
                                        idTable: "idTableBasic",
                                        columns: columnsFinal,
                                        datePivot: false)
                //let tableType = splitType == "table"
                let typeFinal = type == "" || type == "data" ? "#idTableBasic" : type
                webView = """
                    \(getHTMLHeader(triType: columnsF.count == 3))
                    \(datePivotStr)
                    \(dataPivotStr)
                    \(tableBasicStr)
                    \(split ? secondQuery : "")
                \(getHTMLFooter(rows: rowsFinal, columns: columnsF, types: columsType, drills: drills, type: typeFinal))
                """
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
                position: position
            )
        }
        return dataModel
    }
    func getSplit(type: String, table: String = "") -> String {
        let wbSplit = "<div>SplitView</div>"
        //let _ = type == "table" ? type : "container2"
        if type == "table" {
            
        }
        return wbSplit
    }
    func getColumns(columns: [[String: Any]] ) -> [ChatTableColumn] {
        var columnsFinal: [ChatTableColumn] = []
        for (_, column) in columns.enumerated() {
            let isVisible: Bool = column["is_visible"] as? Bool ?? true
            // siempre agregar isVisible
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
            
            let column = ChatTableColumn(name: name,
                                         type: finalType,
                                         originalName: originalName,
                                         formatDate: ffDate,
                                         isVisible: isVisible)
            columnsFinal.append(column)
            
        }
        return columnsFinal
    }
    func getRows(rows: [[Any]], columnsFinal: [ChatTableColumn]) -> ([[String]], [[String]]){
        var rowsFinal: [[String]] = []
        var rowsFinalClean: [[String]] = []
        for row in rows {
            var finalRow: [String] = []
            var finalRowClean: [String] = []
            row.enumerated().forEach { (index, element) in
                if columnsFinal[index].type == .dateString {
                    let strDate = element as? String ?? ""
                    finalRow.append(strDate.toDate2(format: columnsFinal[index].formatDate))
                    finalRowClean.append(strDate)
                } else {
                    finalRow.append("\(element)")
                    finalRowClean.append("\(element)")
                }
            }
            rowsFinalClean.append(finalRowClean)
            rowsFinal.append(finalRow)
        }
        return (rowsFinal, rowsFinalClean)
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
    var loading: Bool
    init(
        displayType: String = "",
        webview: String = "",
        text: String = "",
        type: ChatComponentType = .Introduction,
        idQuery: String = "",
        loading: Bool = false
    ) {
        self.displayType = displayType
        self.webview = webview
        self.text = text
        self.type = type
        self.idQuery = idQuery
        self.loading = loading
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
    var type: ChatComponentType
    var text: String
    var splitView: Bool
    var secondDisplayType: String
    var idQuery: String
    var columnsInfo: [ChatTableColumn]
    var secondQuery: String
    var loading: Bool
    var subDashboardModel : SubDashboardModel
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
        type: ChatComponentType = ChatComponentType.Introduction,
        text: String = "",
        splitView: Bool = false,
        secondDisplayType: String = "",
        idQuery: String = "",
        columnsInfo: [ChatTableColumn] = [],
        secondQuery: String = "",
        loading: Bool = false,
        subDashboardModel: SubDashboardModel = SubDashboardModel()
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
        self.type = type
        self.text = text
        self.splitView = splitView
        self.secondDisplayType = secondDisplayType
        self.idQuery = idQuery
        self.columnsInfo = columnsInfo
        self.secondQuery = secondQuery
        self.loading = loading
        self.subDashboardModel = subDashboardModel
    }
}
struct DataPivotRow{
    var posX: Int
    var posY: Int
    var value: Double
}

