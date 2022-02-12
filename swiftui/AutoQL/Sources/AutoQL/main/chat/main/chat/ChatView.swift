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
    var body: some View{
        MainChatView(
            showingChat: $showingChat,
            isReportPopUp: $isReportPopUp,
            isSQLPopUp: $isSQLPopUp
        )
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .padding(0)
        .background(qlBackgroundColorSecondary)
    }
}
