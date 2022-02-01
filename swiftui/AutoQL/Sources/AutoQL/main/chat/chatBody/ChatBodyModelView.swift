//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

class ChatBodyModelView : ObservableObject {
    @Published var bodyMessages = [ChatComponent]()
    init() {
        bodyMessages = [
            ChatComponent(type: .botmessage),
            ChatComponent(type: .querybuilder)
        ]
    }
    func getDefaultMessage() -> [ChatComponent]{
        return bodyMessages
    }
    func addNewComponent(completion: @escaping([ChatComponent]) -> ()){
        let newComponent = ChatComponent(type: .usermessage)
        let newComponent2 = ChatComponent(type: .botmessage)
        bodyMessages += [newComponent, newComponent2]
        completion([newComponent, newComponent2])
    }
}

