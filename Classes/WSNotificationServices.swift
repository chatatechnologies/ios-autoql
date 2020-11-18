//
//  WSNotificationServices.swift
//  chata
//
//  Created by Vicente Rincon on 21/09/20.
//

import Foundation
class NotificationServices {
    static let instance = NotificationServices()
    var podelModel = PollModel()
    var unacknowledged = 0
    func getStateNotifications(number: Int = 0) {
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications/summary/poll?key=\(DataConfig.authenticationObj.apiKey)&unacknowledged=\(unacknowledged)"
        httpRequest(url) { (response) in
            let data = response["data"] as? [String : Any] ?? [:]
            let referenceID = response["reference_id"] as? String ?? ""
            if referenceID == "" || !referenceID.contains("13"){
                notificationsAttempts += 1
            } else {
                notificationsAttempts = 0
            }
            self.podelModel.acknowledged = data["acknowledged"] as? Int ?? 0
            self.podelModel.dismissed = data["dismissed"] as? Int ?? 0
            self.podelModel.unacknowledged = data["unacknowledged"] as? Int ?? 0
            if self.unacknowledged == 0 {
                self.unacknowledged = data["unacknowledged"] as? Int ?? 0
                NotificationCenter.default.post(name: notifAlert,
                                                object: self.unacknowledged > 0)
            }
        }
    }
    func readNotification() {
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications?key=\(DataConfig.authenticationObj.apiKey)"
        let body: [String: Any] = [
            "notification_id": "null",
            "state": "ACKNOWLEDGED"
        ]
        NotificationCenter.default.post(name: notifAlert,
                                        object: false)
        httpRequest(url, "PUT", body) { (response) in
            self.unacknowledged = 0
        }
    }
    func getNotifications(currentNumber: Int = 0, completion: @escaping CompletionNotifications) {
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications?key=\(DataConfig.authenticationObj.apiKey)&offset=\(currentNumber)&limit=10"
        httpRequest(url) { (response) in
            let dataResponse = response["data"] as? [String : Any] ?? [:]
            let items = dataResponse["items"] as? [[String : Any]] ?? []
            var finalNotifications: [NotificationItemModel] = []
            items.forEach { (item) in
                var newNotification = NotificationItemModel()
                newNotification.createdAt = String(item["created_at"] as? Int ?? 0).toDate(true, true)
                newNotification.id = String(item["id"] as? Int ?? 0) 
                newNotification.notificationType = item["notification_type"] as? String ?? ""
                newNotification.ruleId = item["rule_id"] as? Int ?? 0
                newNotification.ruletype = item["rule_type"] as? String ?? ""
                newNotification.ruleQuery = item["rule_query"] as? String ?? ""
                newNotification.ruleTitle = item["rule_title"] as? String ?? ""
                newNotification.ruleMessage = item["rule_message"] as? String ?? ""
                newNotification.state = item["state"] as? String ?? ""
                finalNotifications.append(newNotification)
            }
            completion(finalNotifications)
        }
    }
    func deleteNotification(idNotification: String) {
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications/\(idNotification)?key=\(DataConfig.authenticationObj.apiKey)"
        let body = ["key" : "\(DataConfig.authenticationObj.apiKey)"]
        httpRequest(url, "DELETE", body) { (response) in
        }
    }
}

