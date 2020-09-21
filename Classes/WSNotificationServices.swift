//
//  WSNotificationServices.swift
//  chata
//
//  Created by Vicente Rincon on 21/09/20.
//

import Foundation
class NotificationServices {
    static let instance = NotificationServices()
    //private var dashList: [DashboardList] = []
    func getNotifications(number: Int = 0) {
        //https://spira-staging.chata.io/autoql/api/v1/rules/notifications/summary/poll?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU&unacknowledged=0
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications/summary/poll?key=\(DataConfig.authenticationObj.apiKey)&unacknowledged=\(number)"
        httpRequest(url) { (response) in
            let data = response["data"] as? [String : Any] ?? [:]
            var podelModel = PollModel()
            podelModel.acknowledged = data["acknowledged"] as? Int ?? 0
            podelModel.dismissed = data["dismissed"] as? Int ?? 0
            podelModel.unacknowledged = data["unacknowledged"] as? Int ?? 0
            print(podelModel)
            print(podelModel)
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
    init(
           items: NotificationItemModel = NotificationItemModel(),
           limit: Int = 0,
           notifications: NotificationItemModel = NotificationItemModel(),
           offset: Int = 0,
           pageNumber: Int = 0,
           pagination: PaginationNotificationModel = PaginationNotificationModel(),
           totalElements: Int = 0,
           totalPages: Int = 0
    ) {
        self.items = items
        self.limit = limit
        self.notifications = notifications
        self.offset = offset
        self.pageNumber = pageNumber
        self.pagination = pagination
        self.totalElements = totalElements
        self.totalPages = totalPages
    }
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
    init(
        createdAt: String = "",
        id: String = "",
        notificationType: String = "",
        ruleId: Int = 0,
        ruleMessage: String = "",
        ruleQuery: String = "",
        ruleTitle: String = "",
        ruletype: String = "",
        state: String = ""
    ) {
        self.createdAt = createdAt
        self.id = id
        self.notificationType = notificationType
        self.ruleId = ruleId
        self.ruleMessage = ruleMessage
        self.ruleQuery = ruleQuery
        self.ruleTitle = ruleTitle
        self.ruletype = ruletype
        self.state = state
    }
}
struct PollModel {
    var acknowledged: Int
    var dismissed: Int
    var unacknowledged: Int
    init(
        acknowledged: Int = 0,
        dismissed: Int = 0,
        unacknowledged: Int = 0) {
        self.acknowledged = acknowledged
        self.dismissed = dismissed
        self.unacknowledged = unacknowledged
    }
}
struct PaginationNotificationModel {
    var currentPage: Int
    var nextUrl: String
    var pageSize: Int
    var previousUrl: String
    var totalItems: Int
    var totalPages: Int
    init(
        currentPage: Int = 0,
        nextUrl: String = "",
        pageSize: Int = 0,
        previousUrl: String = "",
        totalItems: Int = 0,
        totalPages: Int = 0
    ) {
        self.currentPage = currentPage
        self.nextUrl = nextUrl
        self.pageSize = pageSize
        self.previousUrl = previousUrl
        self.totalItems = totalItems
        self.totalPages = totalPages
    }
}
