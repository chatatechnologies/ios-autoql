//
//  DashboardService.swift
//  chata
//
//  Created by Vicente Rincon on 06/05/20.
//

import Foundation
class DashboardService {
    static let instance = DashboardService()
    private var dashList: [DashboardList] = []
    func getDashboards(apiKey: String, completion: @escaping CompletionDashboards) {
        let projectID = ChataServices.instance.getProjectID()
        let url = "\(wsDashboard)\(apiKey)&project_id=\(projectID)"
        httpRequest(url, integrator: true) { (response) in
            let items = response["items"] as? [[String: Any]] ?? []
            DashboardService.instance.dashList = []
            items.forEach { (item) in
                let createdAt = item["created_at"] as? String ?? ""
                let data = item["data"] as? [[String: Any]] ?? []
                var dashboards: [DashboardModel] = []
                for dash in data {
                    let newDash = self.makeDash(dash: dash)
                    dashboards.append(newDash)
                }
                let id = item["id"] as? Int ?? 0
                let name = item["name"] as? String ?? ""
                let updateAt = item["update_at"] as? String ?? ""
                let dashFinal = DashboardList(createdAt: createdAt,
                                              data: dashboards,
                                              id: id,
                                              name: name,
                                              updatedAt: updateAt)
                DashboardService.instance.dashList.append(dashFinal)
            }
            completion(DashboardService.instance.dashList)
            //completion(matches)
        }
    }
    func getDashQuery(query: String,
                      type: ChatComponentType,
                      position: Int = 0,
                      column: Int = 0,
                      second: String = "",
                      completion: @escaping CompletionChatComponentModel) {
        var base = DataConfig.authenticationObj.domain
        if base.last == "/" {
            base.removeLast()
        }
        let url = "\(base)/autoql/api/v1/query?key=\(DataConfig.authenticationObj.apiKey)"
        let body: [String: Any] = [
                    "debug": true,
                    "source": "dashboards.user",
                    "test": true,
                    "text": query
                ]
        if query == "" {
            var finalComponent = ChataServices().getDataComponent(response: [:],
                                                                      type: "",
                                                                      position: position)
            finalComponent.text = "No query was supplied for this tile."
            completion(finalComponent)
        } else {
            httpRequest(url, "POST", body) { (response) in
                print(query)
                let referenceId = response["reference_id"] as? String ?? ""
                let typeFinal = type == .Introduction ? "" : type.rawValue
                /*if referenceId == "1.1.430" || referenceId == "1.1.431"{
                    
                    ChataServices.instance.getSuggestionsQueries(query: query) { (items) in
                        let finalComponent = ChataServices().getDataComponent(response: response, type: typeFinal, items: items, position: position, second: second)
                        completion(finalComponent)
                    }
                } else {*/
                var finalComponent = ChataServices().getDataComponent(response: response,
                                                                      type: typeFinal,
                                                                      position: position,
                                                                      mainColumn: column,
                                                                      second: second)
                if referenceId == "1.1.431"{
                    finalComponent.text = "Invalid Request Parameters"
                }
                    completion(finalComponent)
                //}
            }
        }
    }
    func getDrillDownDashboard(idQuery: String, name: [String], value: [String], completion: @escaping CompletionChatComponentModel){
        /*var base = DataConfig.authenticationObj.domain
        if base.last == "/" {
            base.removeLast()
        }
        let url = "\(base)/autoql/api/v1/query/\(idQuery)/drilldown?key=\(DataConfig.authenticationObj.apiKey)"
        var columns: [[String: Any]] = []
        if value.count > 0 {
            name.enumerated().forEach { (index, nam) in
                let newColumn = [
                    "name" : nam,
                    "value" : value[index]
                ]
                columns.append(newColumn)
            }
        }
        let body: [String: Any] = [
                    "translation": "include",
                    "columns": columns,
                    "test": true
                ]
        httpRequest(url, "POST", body) { (response) in
            let finalComponent = ChataServices().getDataComponent(response: response)
            completion(finalComponent)
        }*/
        
    }
    func makeDash(dash: [String: Any]) -> DashboardModel{
        let minW = dash["minW"] as? Int ?? 0
        let staticVar = dash["static"] as? Int ?? 0
        let maxH = dash["maxH"] as? Int ?? 0
        let minH = dash["minH"] as? Int ?? 0
        let displayType = dash["displayType"] as? String ?? ""
        let posX = dash["x"] as? Int ?? 0
        let posY = dash["y"] as? Int ?? 0
        let identify = dash["i"] as? Int ?? 0
        let query = dash["query"] as? String ?? ""
        let isNewTile = dash["isNewTile"] as? Int ?? 0
        let title = dash["title"] as? String ?? "Untitled"
        let key = dash["key"] as? String ?? ""
        let moved = dash["moved"] as? Int ?? 0
        let posH = dash["h"] as? Int ?? 0
        let posW = dash["w"] as? Int ?? 0
        let splitView = dash["splitView"] as? Bool ?? false
        let secondQuery = dash["secondQuery"] as? String ?? ""
        let secondDisplayType = dash["secondDisplayType"] as? String ?? ""
        let finalTitle = title == "" ? (query == "" ? "Untitled" : query) : title
        let dataConfig = dash["dataConfig"] as? [String: Any] ?? [:]
        let secondDataConfig = dash["secondDataConfig"] as? [String: Any] ?? [:]
        let stringColumnIndexSecond = secondDataConfig["stringColumnIndex"] as? Int ?? 0
        let stringColumnIndex = dataConfig["stringColumnIndex"] as? Int ?? 0
        return DashboardModel(minW: minW, staticVar: staticVar, maxH: maxH,
                              minH: minH, displayType: displayType,
                              posX: posX, posY: posY, identify: identify,
                              query: query, isNewTile: isNewTile,
                              title: finalTitle, key: key, moved: moved,
                              posH: posH, posW: posW, splitView: splitView,
                              secondDisplayType: secondDisplayType,
                              secondQuery: secondQuery, stringColumnIndex: stringColumnIndex,
                              stringColumnIndexSecond: stringColumnIndexSecond)
    }
}
