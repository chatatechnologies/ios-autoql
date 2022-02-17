//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI

struct ExploreView: View {
    @Binding var showingChat: Bool
    @Binding var sendQuery: String
    @Binding var sendRequest: Bool
    @State var valueInput = ""
    @State var isEmptyView = false
    var body: some View {
        VStack{
            ChatTopBarView(
                showingChat: $showingChat,
                label: "Explore Queries"
            ){}
            QLInputText(
                label: "Search relevant queries by topic",
                value: $valueInput
            ).padding()
            Group {
                if isEmptyView {
                    ExploreEmptyView()
                } else {
                    ExploreListView(
                        sendQuery: $sendQuery,
                        sendRequest: $sendRequest
                    )
                }
            }
            Spacer()
        }.background(qlBackgroundColorSecondary)
    }
}
