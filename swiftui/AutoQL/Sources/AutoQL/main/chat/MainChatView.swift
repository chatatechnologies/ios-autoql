//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct MainChatView: View {
    @Binding var showingChat: Bool
    @State var valueInput = ""
    @State var allComponents: [ChatComponent] = []
    var body: some View {
        VStack{
            ChatTopBarView(
                showingChat: $showingChat,
                allComponents: $allComponents
            )
            ChatBodyView(
                allComponents: $allComponents,
                queryValue: $valueInput
            )
            ChatBarBottomView(
                value: $valueInput,
                allComponents: $allComponents
            )
            Spacer()
        }
    }
}
