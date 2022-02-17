//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/02/22.
//

import Foundation
struct NotificationContentModel {
    var typeContent: DataChatType
    var content: String
    init(
        typeContent: DataChatType = .botresponseText,
        content: String = ""
    ){
        self.typeContent = typeContent
        self.content = content
    }
}
