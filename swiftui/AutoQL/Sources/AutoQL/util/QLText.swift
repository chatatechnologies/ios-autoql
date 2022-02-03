//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 28/01/22.
//

import SwiftUI

struct QLText: View {
    var label: String
    var color = qlTextColorPrimary
    var padding = 16.0
    var body: some View {
        Text(label)
            .font(.system(size: 15.0))
            .foregroundColor(color)
            .padding(padding)
            .frame(alignment: .leading)
    }
}
