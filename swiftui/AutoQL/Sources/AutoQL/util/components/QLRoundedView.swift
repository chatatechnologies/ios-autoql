//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import SwiftUI

struct QLRoundedView: View {
    var color = qlBackgroundColorPrimary
    var cornerRadius = 20.0
    var body: some View {
        AnyView(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
        )
    }
}
