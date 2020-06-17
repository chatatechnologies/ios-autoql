//
//  ChataServices.swift
//  chata
//
//  Created by Vicente Rincon on 11/03/20.
//

import Foundation
typealias CompletionArrString = (_ response: [String]) -> Void
typealias CompletionChatComponentModel = (_ response: ChatComponentModel) -> Void
typealias CompletionDashboards = (_ response: [DashboardModel]) -> Void
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
    func setLogin(active: Bool) {
        ChataServices.instance.isLoggin = active
    }
    func logout(completion: @escaping CompletionChatSuccess){
        DataConfig.authenticationObj.token = ""
        ChataServices.instance.jwt = ""
        DataConfig.authenticationObj.apiKey = ""
        ChataServices.instance.isLoggin = false
        ChataServices.instance.projectID = ""
        ChataServices.instance.username = ""
        wsUrlDynamic = ""
        DataConfig.authenticationObj.domain = ""
        completion(true)
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
                DataConfig.authenticationObj.apiKey = parameters["apiKey"] as? String ?? ""
                DataConfig.authenticationObj.token = result
                ChataServices.instance.username = user
                completion(result != "")
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
            let loginSuccess = result != "" && result.count > 30
            ChataServices.instance.isLoggin = loginSuccess
            DataConfig.authenticationObj.domain = (parameters["domain"] as? String ?? "")
            wsUrlDynamic = DataConfig.authenticationObj.domain
            ChataServices.instance.projectID = parameters["projectID"] as? String ?? ""
            completion(loginSuccess)
            //completion(matches)
        }
    }
    func getQueries(query: String, completion: @escaping CompletionArrString){
        let handleQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlRequest = "\(wsAutocomplete)&q=\(handleQuery)&projectid=\(projectID)"
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query/autocomplete?text=\(handleQuery)&key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = ChataServices.instance.isLoggin ? urlRequestUser : urlRequest
        httpRequest(urlFinal) { (response) in
            let responseFinal: [String: Any] = ChataServices.instance.isLoggin ? response["data"] as? [String: Any] ?? [:] : response
            let matches = responseFinal["matches"] as? [String] ?? []
            completion(matches)
        }
    }
    func getSafetynet(query: String, completion: @escaping CompletionChatSafetynet){
        let handleQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlRequest = ChataServices.instance.isLoggin
            ? "\(wsUrlDynamic)/api/v1/query/validate?text=\(handleQuery)&key=\(DataConfig.authenticationObj.apiKey)"
            : "\(wsSafetynet)\(handleQuery)&projectId=\(projectID)"
        httpRequest(urlRequest) { (response) in
            if ChataServices.instance.isLoggin {
                completion([])
            } else {
                let fullSuggestion = response["full_suggestion"] as? [[String: Any]] ?? []
                let final: [ChatFullSuggestion] = fullSuggestion.map { (suggestion) -> ChatFullSuggestion in
                    let start = suggestion["start"] as? Int ?? 0
                    let end = suggestion["end"] as? Int ?? 0
                    let suggs = suggestion["suggestion_list"] as? [[String: Any]] ?? []
                    let suggestion: [String] = suggs.map { (sugg) -> String in
                        let text = sugg["text"] as? String ?? ""
                        return text
                    }
                    let model = ChatFullSuggestion(suggestionList: suggestion, start: start, end: end)
                    return model
                }
                completion(final)
            }
        }
    }
    func getDataChat(query: String, completion: @escaping CompletionChatComponentModel){
        let body: [String: Any] = ChataServices.instance.isLoggin
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
        let urlFinal = ChataServices.instance.isLoggin ? urlRequestUser : urlRequest
        httpRequest(urlFinal, "POST", body) { (response) in
            //let responseFinal: [String: Any] = ChataServices.instance.isLoggin ? response["data"] as? [String: Any] ?? [:] : response
            let finalComponent = self.getDataComponent(response: response)
            completion(finalComponent)
            //completion(matches)
        }
    }
    func getDataChatDrillDown(obj: String, idQuery: String, name: String, completion: @escaping CompletionChatComponentModel){
        let guion = obj.contains("_")
        var group_bys: [String: Any] = [:]
        if guion{
            let values = obj.split(separator: "_")
            let keys = name.split(separator: "º")
            group_bys = [
                String(keys[0]): String(values[0]),
                String(keys[1]): String(values[1])
            ]
        } else {
            if name != ""{
                group_bys = [
                    name: obj
                ]
            }
        }
        let body: [String: Any] = ChataServices.instance.isLoggin
            ?   [:]
            :   [
                    "query_id": idQuery,
                    "group_bys": group_bys,
                    "username": "demo",
                    "customer_id": "accounting-demo",
                    "user_id": "vidhya@chata.ai",
                    "debug": true
                ]
        //let urlRequest = wsQuery
        let urlRequestUser = "\(wsUrlDynamic)/autoql/api/v1/query?key=\(DataConfig.authenticationObj.apiKey)"
        let urlFinal = ChataServices.instance.isLoggin ? urlRequestUser : "\(wsQuery)/drilldown"
        httpRequest(urlFinal, "POST", body) { (response) in
            //let responseFinal: [String: Any] = ChataServices.instance.isLoggin ? response["data"] as? [String: Any] ?? [:] : response
            let finalComponent = self.getDataComponent(response: response)
            completion(finalComponent)
            //completion(matches)
        }
    }
    func getDataComponent(response: [String: Any], type: String = "", split: Bool = false, splitType: String = "") -> ChatComponentModel {
        let data = response["data"] as? [String: Any] ?? [:]
        var dataModel = ChatComponentModel()
        let message = response["message"] as? String ?? ""
        dataModel.text = message
        if data.count > 0 {
            let columns = data["columns"] as? [[String: Any]] ?? []
            let finalType = type == "" ? (data["display_type"] as? String ?? "") : type
            var displayType: ChatComponentType = ChatComponentType.withLabel(finalType)
            let idQuery = data["query_id"] as? String ?? ""
            let rows = data["rows"] as? [[Any]] ?? []
            var columnsFinal: [ChatTableColumn] = []
            var rowsFinal: [[String]] = []
            var textFinal = ""
            var user = true
            var numRow = 20
            for column in columns {
                let name: String = ChataServices.instance.isLoggin ? (column["display_name"] as? String ?? "") : (column["name"] as? String ?? "")
                let originalName = column["name"] as? String ?? ""
                let type: String = column["type"] as? String ?? ""
                let column = ChatTableColumn(name: name, type: ChatTableColumnType.withLabel(type), originalName: originalName )
                columnsFinal.append(column)
            }
            for row in rows {
                let finalRow: [String] = row.map { (element) -> String in
                    return "\(element)"
                }
                if finalRow.count == 1 && rows.count == 1{
                    displayType = .Introduction
                    textFinal = finalRow[0].toMoney()
                    user = false
                }
                rowsFinal.append(finalRow)
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
                if supportTri {
                    var (dataPivot, drill) = getDataPivotColumn(rows: rowsFinal)
                    drills = drill
                    let dataPivotColumnsTemp = dataPivot[0]
                    dataPivot.remove(at: 0)
                    dataPivotStr = tableString(
                        dataTable: dataPivot,
                        dataColumn: dataPivotColumnsTemp,
                        idTable: "idTableDataPivot",
                        columnsType: columsType,
                        datePivot: true)
                }
                if existsDatePivot {
                    var datePivot =  getDatePivot(rows: rowsFinal)
                    let columnsTemp = datePivot[0]
                    datePivot.remove(at: 0)
                    datePivotStr = tableString(dataTable: datePivot,
                                            dataColumn: columnsTemp,
                                            idTable: "idTableDatePivot",
                                            columnsType: columsType,
                                            datePivot: true)
                }
                tableBasicStr = tableString(dataTable: rowsFinal,
                                        dataColumn: columnsF,
                                        idTable: "idTableBasic",
                                        columnsType: columsType,
                                        datePivot: false)
                /*let table = tableString(dataTable: rowsFinal,
                                        dataColumn: columnsF,
                                        idTable: "a",
                                        columnsType: columsType,
                                        datePivot: existsDatePivot)*/
                let tableType = splitType == "table"
                let typeFinal = type == "" ? "#idTableBasic" : type
                webView = """
                    \(getHTMLHeader(triType: columnsF.count == 3))
                    \(datePivotStr)
                    \(dataPivotStr)
                    \(tableBasicStr)
                \(getHTMLFooter(rows: rowsFinal, columns: columnsF, types: columsType, drills: drills, type: typeFinal, split: tableType))
                """
                if split {
                    print(webView)
                }
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
                text: textFinal,
                user: user,
                webView: webView,
                numRow: numRow,
                options: suggestions,
                dataRows: rowsFinal,
                colunms: columsType,
                idQuery: idQuery,
                columnsInfo: columnsFinal
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
        columnsInfo: [ChatTableColumn] = []
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
    }
}
struct DataPivotRow{
    var posX: Int
    var posY: Int
    var value: Double
}

