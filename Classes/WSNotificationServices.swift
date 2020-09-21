//
//  WSNotificationServices.swift
//  chata
//
//  Created by Vicente Rincon on 21/09/20.
//

import Foundation
class WSNotificationServices {
    static let instance = WSNotificationServices()
    
    func getNotifications( completion: @escaping CompletionQueryTips) {
        //https://spira-staging.chata.io/autoql/api/v1/rules/notifications/summary/poll?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU&unacknowledged=0
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications/summary/poll?key=\(DataConfig.authenticationObj.apiKey)&unacknowledged=0"
        httpRequest(url) { (response) in
            
            let QTData = QTModel(items: items, pagination: paginator)
            completion(QTData)
            //completion(matches)
        }
    }
}
struct NotificationModel{
    var items: NotificationItemModel
    var limit: Int
    var notifications: NotificationItemModel
    var offset: Int
    var pageNumber: Int
    var pagination: PaginationNotificationModel
    var totalElements: Int
    var totalPages: Int
}
struct NotificationItemModel {
    var createdAt: String
    var id: String
    var notificationType: String
    var ruleId: Int
    var ruleMessage: String
    var ruleQuery: String
    var ruleTitle: String
    var ruletype: String
    var state: String
}
struct PollModel {
    var acknowledged: Int
    var dismissed: Int
    var unacknowledged: Int
}
struct PaginationNotificationModel {
    var currentPage: Int
    var nextUrl: String
    var pageSize: Int
    var previousUrl: String
    var totalItems: Int
    var totalPages: Int
}
