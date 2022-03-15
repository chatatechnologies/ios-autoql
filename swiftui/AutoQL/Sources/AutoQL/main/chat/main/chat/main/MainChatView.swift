//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct MainChatView: View {
    @Binding var showingChat: Bool
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    @Binding var valueInput: String
    @Binding var sendRequest: Bool
    @StateObject private var viewModel = MainChatViewModel()
    var body: some View {
        VStack{
            ChatTopBarView(
                showingChat: $showingChat,
                label: "Data Messenger",
                actionButtons: true,
                removeItems: viewModel.cleanChat
            )
            ChatBodyView(
                allComponents: $viewModel.allComponents,
                queryValue: $valueInput,
                isReportPopUp: $isReportPopUp,
                isSQLPopUp: $isSQLPopUp,
                sendRequest: $sendRequest
            )
            ChatBarBottomView(
                value: $valueInput,
                allComponents: $viewModel.allComponents
            )
            Spacer()
        }.onAppear {
            if AutoQLConfig.shared.authenticationObj.token.isEmpty{
                viewModel.cleanChat()
            }
        }

    }
}
