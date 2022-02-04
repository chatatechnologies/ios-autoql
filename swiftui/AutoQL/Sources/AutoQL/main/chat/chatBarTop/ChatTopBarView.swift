//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatTopBarView: View {
    @Binding var showingChat: Bool
    @Binding var allComponents: [ChatComponent]
    var body: some View {
        HStack{
            Button("x", action: {
                showingChat = false
            })
            Spacer()
            Text("Data Messenger").foregroundColor(.white)
            Spacer()
            Button("D", action: {
                let defaultValue: [ChatComponent] = [allComponents[0], allComponents[1]]
                allComponents = defaultValue
            })
        }.padding(
            EdgeInsets(
                top: 32,
                leading: 16,
                bottom: 16,
                trailing: 16))
        .background(qlAccentColor)
    }
}
