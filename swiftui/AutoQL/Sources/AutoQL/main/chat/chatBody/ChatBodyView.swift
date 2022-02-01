//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBodyView: View {
    @Binding var allComponents : [ChatComponent]
    @StateObject private var service = ChatBodyModelView()
    var body: some View {
        ScrollView {
            VStack{
                ForEach(allComponents, id:\.self) {
                    bod in
                    switch(bod.type){
                    case .usermessage:
                        ChatUserMessageView(label: bod.label)
                    case .botmessage:
                        ChatBotMessageView(label: bod.label)
                    case .querybuilder:
                        ChatQueryBuilder()
                    }
                }
            }.onAppear {
                allComponents = service.getDefaultMessage()
            }
        }
    }
}

