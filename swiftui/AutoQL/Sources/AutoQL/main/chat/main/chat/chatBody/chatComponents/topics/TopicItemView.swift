//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 02/02/22.
//

import SwiftUI

struct TopicItemView: View{
    var label: String
    var isSecondLevel = false
    var onClick: () -> Void
    @Binding var value: String
    var body: some View{
        HStack{
            QLText(label: label, padding: 0)
            Spacer()
            Button {
                if isSecondLevel{
                    value = label
                }
                onClick()
            } label: {
                ImagePath(
                    name: "icArrowRight",
                    size: 20,
                    tintColor: true
                )
            }
        }.listRowBackground(qlBackgroundColorPrimary)
    }
}

