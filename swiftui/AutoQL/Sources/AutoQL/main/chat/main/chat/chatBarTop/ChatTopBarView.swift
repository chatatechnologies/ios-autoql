//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatTopBarView: View {
    @Binding var showingChat: Bool
    var label: String
    var actionButtons: Bool = false
    @State var removeItems: () -> Void
    var body: some View {
        HStack{
            Button {
                showingChat = false
            } label: {
                ImagePath(name: "icCancel", size: 20)
            }
            Spacer()
            Text(label).foregroundColor(.white)
            Spacer()
            if actionButtons {
                Button {
                    removeItems()
                } label: {
                    ImagePath(name: "icDeleteBar", size: 20)
                }
            }
        }.padding(
            EdgeInsets(
                top: 32,
                leading: 16,
                bottom: 16,
                trailing: 16))
        .background(qlAccentColor)
    }
}
