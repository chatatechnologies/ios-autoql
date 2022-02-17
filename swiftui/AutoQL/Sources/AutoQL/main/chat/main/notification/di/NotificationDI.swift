//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/02/22.
//

import Foundation
func getNotifications() -> [NotificationModel] {
    return [
        NotificationModel(
            name: "test",
            details: "details",
            date: "May 18, 2022",
            query: "total sales",
            content: NotificationContentModel(
                typeContent: .botresponseText,
                content: "123000"
            )
        ),
        NotificationModel(
            name: "test2",
            details: "details2",
            date: "May 8, 2021",
            query: "total sales",
            content: NotificationContentModel(
                typeContent: .webview,
                content: generateWB()
            )
        )
    ]
}
