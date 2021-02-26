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
        let url = "\(wsUrlDynamic)\(wsDataAlerts)/summary/poll?key=\(DataConfig.authenticationObj.apiKey)&unacknowledged=\(unacknowledged)"
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
        let url = "\(wsUrlDynamic)\(wsDataAlerts)?key=\(DataConfig.authenticationObj.apiKey)"
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
    func getQueryNotification(idQuery: String, completion: @escaping CompletionChatComponentModel) {
        let url = "\(wsGetQueryNotification)\(idQuery)?key=\(DataConfig.authenticationObj.apiKey)"
        httpRequest(url) { (response) in
            let dataResponse = response["query_result"] as? [String : Any] ?? [:]
            let finalComponent = ChataServices.instance.getDataComponent(response: dataResponse)
            completion(finalComponent)
        }
    }
    func getNotifications(currentNumber: Int = 0, completion: @escaping CompletionNotifications) {
        let url = "\(wsUrlDynamic)\(wsDataAlerts)?key=\(DataConfig.authenticationObj.apiKey)&offset=\(currentNumber)&limit=10"
        httpRequest(url) { (response) in
            let dataResponse = response["data"] as? [String : Any] ?? [:]
            let items = dataResponse["items"] as? [[String : Any]] ?? []
            var finalNotifications: [NotificationItemModel] = []
            items.forEach { (item) in
                var newNotification = NotificationItemModel()
                newNotification.createdAt = String(item["created_at"] as? Int ?? 0).toDate(true, true)
                newNotification.id = item["id"] as? String ?? ""
                newNotification.notificationType = item["notification_type"] as? String ?? ""
                newNotification.dataAlertId = item["data_alert_id"] as? Int ?? 0
                newNotification.dataReturnType = item["data_return_type"] as? String ?? ""
                newNotification.dataReturnQuery = item["data_return_query"] as? String ?? ""
                newNotification.title = item["title"] as? String ?? ""
                newNotification.message = item["message"] as? String ?? ""
                newNotification.state = item["state"] as? String ?? ""
                finalNotifications.append(newNotification)

/*created_at: 1605651303
                 data_alert_id: "da_YTdjZTdhNDgtM2QzZS00NmJmLTg0ODktODAwOTBmNWE1NWY3"
                 data_alert_type: "CUSTOM"
                 data_return_query: "total sales"
                 expression: [{id: "97742ab2-8c18-4c56-a893-00336b9b6532", term_type: "group", condition: "TERMINATOR",…}]
                 id: "nt_NGM5Nzg1ODAtNWI4My00ZTg1LWFhZmQtNGEyNzY4ZjYyOWI5"
                 message: "Test Message"
                 notification_type: "PERIODIC"
                 outcome: "TRUE"
                 state: "ACKNOWLEDGED"
                 title: "Test"*/
            }
            completion(finalNotifications)
        }
    }
    func deleteNotification(idNotification: String) {
        let url = "\(wsUrlDynamic)\(wsDataAlerts)/\(idNotification)?key=\(DataConfig.authenticationObj.apiKey)"
        let body = ["key" : "\(DataConfig.authenticationObj.apiKey)"]
        httpRequest(url, "DELETE", body) { (response) in
        }
    }
}

