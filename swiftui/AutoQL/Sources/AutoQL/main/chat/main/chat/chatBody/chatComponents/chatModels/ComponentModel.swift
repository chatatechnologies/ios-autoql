//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 28/01/22.
//

import SwiftUI
struct ComponentModel: Hashable{
    var uid: UUID
    var type: DataChatType
    var label: String
    init(
        type: DataChatType = .botmessage,
        label: String = "",
        uid: UUID = UUID()
    ){
        self.type = type
        self.label = label
        self.uid = uid
    }
}
enum DataChatType {
    case botmessage,
         usermessage,
         querybuilder,
         botresponseText,
         webview,
         suggestion
}
