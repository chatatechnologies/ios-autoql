//
//  SwiftUIView 2.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBarBottomView: View {
    @Binding var value: String
    @Binding var allComponents : [ChatComponent]
    var service = ChatBarBottomModelView()
    var body: some View {
        HStack{
            TextField("Type your Queries here", text: $value)
                .padding()
                .background(
                    AnyView(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(qlBackgroundColorPrimary)
                    )
                )
            Button("SEND") {
                service.addComponentToChat { newComponents in
                    allComponents += newComponents
                }
            }
            Text("G")
        }.padding()
            .background(qlBackgroundColorSecondary)
    }
}

