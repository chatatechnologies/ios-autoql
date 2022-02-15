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
    @State var allComponents: [ChatComponent] = []
    var body: some View {
        VStack{
            ChatTopBarView(
                showingChat: $showingChat,
                label: "Data Messenger",
                actionButtons: true,
                removeItems: removeItems
            )
            ChatBodyView(
                allComponents: $allComponents,
                queryValue: $valueInput,
                isReportPopUp: $isReportPopUp,
                isSQLPopUp: $isSQLPopUp,
                sendRequest: $sendRequest
            )
            ChatBarBottomView(
                value: $valueInput,
                allComponents: $allComponents
            )
            Spacer()
        }
    }
    func removeItems() {
        let defaultValue: [ChatComponent] = [allComponents[0], allComponents[1]]
        allComponents = defaultValue
    }
}
