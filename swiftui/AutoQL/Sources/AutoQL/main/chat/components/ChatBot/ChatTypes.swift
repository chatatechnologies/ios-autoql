//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 28/01/22.
//

import SwiftUI
struct ChatComponent: Hashable{
    var type: DataChat
    var label: String
    init(
        type: DataChat = .botmessage,
        label: String = "test"
    ){
        self.type = type
        self.label = label
    }
}
enum DataChat {
    case botmessage, usermessage
}
