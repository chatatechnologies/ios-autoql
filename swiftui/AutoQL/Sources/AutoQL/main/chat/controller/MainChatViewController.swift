//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 08/02/22.
//

import SwiftUI

struct MainChatViewController: View {
    @Binding var showingChat: Bool
    @State private var isReportPopUp: Bool = false
    @State private var isSQLPopUp: Bool = false
    @State var optSelected: ChatSideMenuType = .chat
    @State var sendQuery = ""
    @State var sendRequest = false
    var sizeMenu = 30.0
    var body: some View{
        ZStack{
            HStack(spacing: 0){
                chatSideMenuView(optSelected: $optSelected)
                    .frame(maxWidth: sizeMenu, maxHeight: .infinity)
                .background(.black.opacity(0.3))
                .onTapGesture {
                    self.showingChat.toggle()
                }.padding(0)
                Group {
                    switch(optSelected){
                    case .chat:
                        ChatView(
                            showingChat: $showingChat,
                            isReportPopUp: $isReportPopUp,
                            isSQLPopUp: $isSQLPopUp,
                            valueInput: $sendQuery,
                            sendRequest: $sendRequest
                        )
                    case .explore:
                        ExploreView(
                            showingChat: $showingChat,
                            sendQuery: $sendQuery,
                            sendRequest: $sendRequest
                        ).onChange(of: sendRequest) { newValue in
                            optSelected = .chat
                        }
                    case .notification:
                        NotificationView(
                            showingChat: $showingChat
                        )
                    }
                }
            }
        }
        .onAppear(perform: {
            //optSelected = .notification
            //optSelected = .chat
        })
        .customPopupView(isPresented: $isReportPopUp, popupView: { ReportProblemPopUp(isPresented: $isReportPopUp) })
        .customPopupView(isPresented: $isSQLPopUp, popupView: { SQLPopUp(isPresented: $isSQLPopUp) })
        .edgesIgnoringSafeArea(.all)
        
    }
}
