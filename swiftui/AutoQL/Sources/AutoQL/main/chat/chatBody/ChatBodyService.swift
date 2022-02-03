//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

class ChatBodyService: ObservableObject {
    @Published var bodyMessages = [ChatComponent]()
    init() {
        bodyMessages = [
            ChatComponent(type: .botmessage, label: "Hi! Let’s dive into your data. What can I help you discover today?"),
            ChatComponent(type: .querybuilder)
        ]
    }
    func getDefaultMessage() -> [ChatComponent]{
        return bodyMessages
    }
    func addNewComponent(query: String, completion: @escaping([ChatComponent]) -> ()){
        let newComponent = ChatComponent(type: .usermessage, label: query)
        let newComponent2 = ChatComponent(
            type: .botmessage,
            label: "Response"
        )
        bodyMessages += [newComponent, newComponent2]
        completion([newComponent, newComponent2])
    }
}

