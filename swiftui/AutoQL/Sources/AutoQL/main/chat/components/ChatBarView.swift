//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBarView: View {
    var body: some View {
        HStack{
            Button("x", action: {})
            Spacer()
            Text("Data Messenger").foregroundColor(.white)
            Spacer()
            Button("D", action: {})
        }.padding(
            EdgeInsets(
                top: 32,
                leading: 16,
                bottom: 16,
                trailing: 16))
        .background(accentColorB)
    }
}
