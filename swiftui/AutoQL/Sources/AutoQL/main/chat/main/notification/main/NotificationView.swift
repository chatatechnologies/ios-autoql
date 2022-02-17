//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI

struct NotificationView: View {
    @Binding var showingChat: Bool
    @State var valueInput = ""
    var body: some View {
        VStack{
            ChatTopBarView(
                showingChat: $showingChat,
                label: "Notifications"
            ){}
            Spacer()
            NotificationBodyView()
        }.background(qlBackgroundColorSecondary)
    }
}
