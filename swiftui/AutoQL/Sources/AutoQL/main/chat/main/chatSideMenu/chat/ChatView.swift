//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI
struct ChatView: View{
    @Binding var showingChat: Bool
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    @Binding var valueInput: String
    @Binding var sendRequest: Bool
    var body: some View{
        MainChatView(
            showingChat: $showingChat,
            isReportPopUp: $isReportPopUp,
            isSQLPopUp: $isSQLPopUp,
            valueInput: $valueInput,
            sendRequest: $sendRequest
        )
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .padding(0)
        .background(qlBackgroundColorSecondary)
    }
}
