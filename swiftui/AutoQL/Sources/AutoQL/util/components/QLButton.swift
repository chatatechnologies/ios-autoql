//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import SwiftUI

struct QLButton: View {
    var label: String
    var styleDefault: Bool = false
    var onClick: () -> Void
    var body: some View {
        Button(
            action: onClick) {
                Text(label)
                    .foregroundColor(
                        styleDefault ? qlTextColorPrimary : .white
                    )
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                QLRoundedView(
                    color:
                        styleDefault ? qlBackgroundColorPrimary : qlAccentColor,
                    cornerRadius: 8
                ).shadow(color: qlBorderColor, radius: 2)
            )
    }
}
