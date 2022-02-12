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
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    @StateObject private var service = ChatBodyService()
    var body: some View {
        ScrollView {
            VStack{
                //ForEach(allComponents, id:\.self) {
                ForEach(Array(allComponents.enumerated()), id: \.offset) {
                    //bod in
                    (index, bod) in
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
                        ChatBotMessageView(
                            label: bod.label,
                            position: index,
                            isReportPopUp: $isReportPopUp,
                            isSQLPopUp: $isSQLPopUp,
                            onClick: removeComponent
                        )
                    case .webview:
                        ChatWebView(
                            position: index,
                            isReportPopUp: $isReportPopUp,
                            isSQLPopUp: $isSQLPopUp,
                            onClick: removeComponent
                        )
                    case .suggestion:
                        ChatSuggestion(
                            position: index,
                            isReportPopUp: $isReportPopUp,
                            isSQLPopUp: $isSQLPopUp,
                            removeElement: removeComponent,
                            value: $queryValue,
                            onClick: addNewComponent
                        )
                    }
                }
            }.onAppear {
                allComponents = service.getDefaultMessage()
            }
        }.onAppear {
            UIScrollView.appearance().bounces = false
        }
        .background(qlBackgroundColorSecondary)
    }
    func removeComponent(_ position : Int){
        var listElements = [position]
        if allComponents[position - 1].type == .usermessage {
            listElements.insert(position - 1, at: 0)
        }
        let renevueComponents = allComponents.removeElements(listElements)
        allComponents = renevueComponents
    }
    func addNewComponent(){
        service.addNewComponent(query: queryValue) {
            newComponents in
            allComponents += newComponents
            queryValue = ""
        }
    }
}

