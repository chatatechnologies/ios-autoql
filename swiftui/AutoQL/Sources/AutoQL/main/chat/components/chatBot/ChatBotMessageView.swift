//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBotMessageView: View {
    var label: String
    var body: some View {
        HStack{
            QLText(label: label)
                .background(
                    AnyView(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(qlBackgroundColorPrimary)
                    )
                )
            Spacer()
        }
        .padding(8)
    }
}
struct ChatBotMessageModel: Hashable{
    var label: String
}
