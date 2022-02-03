//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 02/02/22.
//

import SwiftUI

struct QueryBuilderItemView: View{
    var label: String
    var onClick: () -> Void
    @Binding var value: String
    var body: some View{
        HStack{
            QLText(label: label, padding: 0)
            Spacer()
            Button {
                value = label
                onClick()
            } label: {
                Text("N")
            }

        }
    }
}

