//
//  SwiftUIView 2.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct InputView: View {
    @Binding var value: String
    var body: some View {
        HStack{
            TextField("Type your Queries here", text: $value)
                .textFieldStyle(.roundedBorder)
            Text("M")
            Text("G")
        }.padding()
            .background(backgroundColorSecondary)
    }
}

