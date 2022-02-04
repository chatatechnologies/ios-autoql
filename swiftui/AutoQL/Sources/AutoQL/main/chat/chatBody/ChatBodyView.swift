//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBodyView: View {
    @Binding var allComponents : [ChatComponent]
    @Binding var queryValue: String
    @StateObject private var service = ChatBodyService()
    var body: some View {
        ScrollView {
            VStack{
                ForEach(allComponents, id:\.self) {
                    bod in
                    switch(bod.type){
                    case .usermessage:
                        ChatUserMessageView(label: bod.label)
                    case .botmessage:
                        ChatBotResponseText(label: bod.label)
                    case .querybuilder:
                        ChatQueryBuilder(
                            value: $queryValue,
                            onClick: addNewComponent
                        )
                    case .botresponseText:
                        ChatBotMessageView(label: bod.label)
                            .overlay(ChatToolbarOptions(), alignment: .topTrailing)
                    }
                }
            }.onAppear {
                allComponents = service.getDefaultMessage()
            }
        }
    }
    func addNewComponent(){
        service.addNewComponent(query: queryValue) {
            newComponents in
            allComponents += newComponents
            queryValue = ""
        }
    }
}

