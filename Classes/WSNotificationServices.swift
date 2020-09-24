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
    //private var dashList: [DashboardList] = []
    func getStateNotifications(number: Int = 0) {
        //https://spira-staging.chata.io/autoql/api/v1/rules/notifications/summary/poll?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU&unacknowledged=0
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications/summary/poll?key=\(DataConfig.authenticationObj.apiKey)&unacknowledged=\(unacknowledged)"
        httpRequest(url) { (response) in
            let data = response["data"] as? [String : Any] ?? [:]
            self.podelModel.acknowledged = data["acknowledged"] as? Int ?? 0
            self.podelModel.dismissed = data["dismissed"] as? Int ?? 0
            self.podelModel.unacknowledged = data["unacknowledged"] as? Int ?? 0
            if self.unacknowledged == 0 {
                self.unacknowledged = data["unacknowledged"] as? Int ?? 0
                NotificationCenter.default.post(name: notifAlert,
                                                object: self.unacknowledged > 0)
            }
            /*if self.unacknowledged == 0 {
                self.unacknowledged = data["unacknowledged"] as? Int ?? 0
            } else {
                
            }*/
            
            //NotificationCenter.default.post(name: notifAlert,
                                            //object: self.podelModel.unacknowledged > 0)
            //completion(matches)
        }
    }
    func readNotification() {
        //https://spira-staging.chata.io/autoql/api/v1/rules/notifications?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications?key=\(DataConfig.authenticationObj.apiKey)"
        let body: [String: Any] = [
            "notification_id": "null",
            "state": "ACKNOWLEDGED"
        ]
        httpRequest(url, "PUT", body) { (response) in
            print(response)
            //let referenceID = response["reference_id"] as? String ?? ""
            //completion(referenceID == "1.1.200")
        }
    }
    func getNotifications() {
        //https://spira-staging.chata.io/autoql/api/v1/rules/notifications?key=AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU&offset=0&limit=10
        let url = "\(wsUrlDynamic)/autoql/api/v1/rules/notifications?key=\(DataConfig.authenticationObj.apiKey)&offset=0&limit=10"
        httpRequest(url) { (response) in
            let dataResponse = response["data"] as? [String: Any] ?? [:]
            let newNotification =
        }
        
    }
}

