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
        let question = ChatComponent(type: .usermessage, label: query)
        /*let answer = ChatComponent(
            type: .botresponseText,
            label: "Response"
        )*/
        let answer = ChatComponent(type: .webview, label: "")
        bodyMessages += [question, answer]
        completion([question, answer])
    }
}

