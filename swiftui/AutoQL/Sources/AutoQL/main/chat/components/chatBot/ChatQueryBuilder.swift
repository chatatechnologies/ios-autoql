//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

struct ChatQueryBuilder: View {
    var body: some View {
        HStack{
            QLText(label: "Some things you can ask me:")
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
