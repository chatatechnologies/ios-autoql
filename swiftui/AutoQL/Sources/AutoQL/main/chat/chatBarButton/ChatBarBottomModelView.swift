//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

class ChatBarBottomModelView {
    var serviceBodyChat = ChatBodyService()
    func addComponentToChat(query: String, completion: @escaping([ChatComponent]) -> ()){
        serviceBodyChat.addNewComponent(query: query) { newComponents in
            completion(newComponents)
        }
    }
}
