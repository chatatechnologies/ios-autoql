//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

class ChatBarBottomModelView {
    var serviceBodyChat = ChatBodyModelView()
    func addComponentToChat(completion: @escaping([ChatComponent]) -> ()){
        serviceBodyChat.addNewComponent { newComponents in
            completion(newComponents)
        }
    }
}
