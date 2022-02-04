//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 03/02/22.
//

import SwiftUI

struct ChatBotResponseText: View {
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

