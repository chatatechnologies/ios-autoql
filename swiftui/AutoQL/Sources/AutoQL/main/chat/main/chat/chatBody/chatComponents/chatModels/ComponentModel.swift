//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 28/01/22.
//

import SwiftUI
struct ComponentModel{
    var uid: UUID
    var type: DataChatType
    var label: String
    var componentInfo: ComponentInfoModel?
    init(
        type: DataChatType = .botmessage,
        label: String = "",
        uid: UUID = UUID(),
        componentInfo: ComponentInfoModel? = nil
    ){
        self.type = type
        self.label = label
        self.uid = uid
        self.componentInfo = componentInfo
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
