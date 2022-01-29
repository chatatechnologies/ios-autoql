//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 28/01/22.
//

import SwiftUI

struct ChatUserMessageView: View {
    var label: String
    var body: some View {
        HStack{
            Spacer()
            Text(label)
                .foregroundColor(qlColorWhite)
                .padding()
                .background(
                    AnyView(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(qlAccentColor)
                    )
                )
        }
        .padding(8)
    }
}
struct ChatUserMessageModel: Hashable{
    var label: String
}
