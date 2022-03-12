//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI
import Combine
struct ChatBodyView: View {
    @Binding var allComponents : [ChatComponent]
    @Binding var queryValue: String
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    @Binding var sendRequest: Bool
    @StateObject private var service = ChatBodyService()
    @State private var messageIDToScroll: UUID?
    let columns = [GridItem(.flexible(minimum: 10))]
    var body: some View {
        VStack{
            ScrollView {
                ScrollViewReader{ proxy in
                    //ForEach(allComponents, id:\.self) {
                    LazyVGrid(columns: columns, spacing:0){
                        ForEach(allComponents.indices, id: \.self) {
                            index in
                            //bod in
                            
                            switch(allComponents[index].type){
                            case .usermessage:
                                ChatUserMessageView(label: allComponents[index].label)
                            case .botmessage:
                                ChatBotResponseText(label: allComponents[index].label)
                            case .querybuilder:
                                TopicView(
                                    value: $queryValue,
                                    onClick: addNewComponent
                                )
                            case .botresponseText:
                                ChatBotMessageView(
                                    label: allComponents[index].label,
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
                        Spacer()
                            .id("bottom")
                        
                    }
                    .onChange(of: allComponents, perform: { _ in
                        withAnimation {
                            proxy.scrollTo("bottom")
                        }
                    })
                }.onAppear {
                    allComponents = service.getDefaultMessage()
                }
            }.onAppear {
                UIScrollView.appearance().bounces = false
                if sendRequest {
                    addNewComponent()
                    sendRequest = false
                }
            }
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
            messageIDToScroll = newComponents.last?.uid
        }
    }
}

