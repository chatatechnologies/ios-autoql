//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 28/01/22.
//

import SwiftUI
struct ChatComponent: Hashable{
    var type: DataChatType
    var label: String
    init(
        type: DataChatType = .botmessage,
        label: String = ""
    ){
        self.type = type
        self.label = label
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
