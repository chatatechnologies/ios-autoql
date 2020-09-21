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
    
}
