//
//  WSQueryTipsServices.swift
//  chata
//
//  Created by Vicente Rincon on 02/09/20.
//

import Foundation
class QTServices {
    static let instance = QTServices()
    func getTips(txtSearch: String, page: Int = 1, pageSize: Int = 7, completion: @escaping CompletionQueryTips) {
        //https://spira-staging.chata.io/autoql/api/v1/query/related-queries?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU&search=sales&page_size=7&page=1
        //https://spira-staging.chata.io/autoql/api/v1/query/related-queries?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU&search=Allsales&page_size=7&page=1
        let handleQuery = txtSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(wsUrlDynamic)/autoql/api/v1/query/related-queries?key=\(DataConfig.authenticationObj.apiKey)&search=\(handleQuery)&page_size=\(pageSize)&page=\(page)"
        httpRequest(url) { (response) in
            let data = response["data"] as? [String: Any] ?? [:]
            let items = data["items"] as? [String] ?? []
            let pagination = data["pagination"] as? [String: Any] ?? [:]
            let currentPage = pagination["current_page"] as? Int ?? 0
            let nextUrl = pagination["next_url"] as? String ?? ""
            let pageSize = pagination["page_size"] as? Int ?? 0
            let totalItems = pagination["total_items"] as? Int ?? 0
            let totalPages = pagination["total_pages"] as? Int ?? 0
            let paginator = PaginationModel(currentPage: currentPage,
                                            nextUrl: nextUrl,
                                            pageSize: pageSize,
                                            totalItems: totalItems,
                                            totalPages: totalPages)
            let QTData = QTModel(items: items, pagination: paginator)
            completion(QTData)
            //completion(matches)
        }
    }
}
