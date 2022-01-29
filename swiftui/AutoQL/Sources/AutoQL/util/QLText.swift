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
    var body: some View {
        Text(label)
            .foregroundColor(color)
            .padding()
    }
}
