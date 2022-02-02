//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

class ChatBarBottomModelView {
    var serviceBodyChat = ChatBodyModelView()
    func addComponentToChat(query: String, completion: @escaping([ChatComponent]) -> ()){
        serviceBodyChat.addNewComponent(query: query) { newComponents in
            completion(newComponents)
        }
    }
}
