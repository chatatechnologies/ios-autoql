//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/02/22.
//

import SwiftUI
struct QLInputText: View {
    var label: String
    @Binding var value: String
    var body: some View{
        TextField(label, text: $value)
            .padding()
            .background(
                AnyView(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(qlBackgroundColorPrimary)
                )
            )
    }
}
