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
    func addNewComponent(
        query: String,
        completion: @escaping([ChatComponent]) -> ()){
        
        completion(getAnswer(query: query))
    }
    func getAnswer(query: String) -> ([ChatComponent]) {
        var components: [ChatComponent] = []
        let question = ChatComponent(type: .usermessage, label: query)
        components.append(question)
        let responseType: DataChatType = .webview
        switch responseType {
        case .botmessage,
             .usermessage,
             .querybuilder,
             .botresponseText,
             .webview:
            let answer = ChatComponent(type: responseType, label: "Response")
            components.append(answer)
        case .suggestion:
            let answer = ChatComponent(type: .botresponseText, label: "I want to make sure I understood your query. Did you mean:")
            let answerSuggestion = ChatComponent(
                type: responseType,
                label: ""
            )
            components += [answer, answerSuggestion]
        }
        return components
    }
}

