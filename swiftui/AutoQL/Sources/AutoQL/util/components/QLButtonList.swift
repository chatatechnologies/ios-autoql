//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/02/22.
//

import SwiftUI

struct QLButtonList: View {
    var label: String
    var onClick: () -> Void
    var body: some View {
        Button(
            action: onClick) {
                Text(label)
                    .foregroundColor( qlTextColorPrimary)
            }
            .padding(0)
            .frame(maxWidth: .infinity)
            .background(
                qlBackgroundColorSecondary
            )
    }
}
