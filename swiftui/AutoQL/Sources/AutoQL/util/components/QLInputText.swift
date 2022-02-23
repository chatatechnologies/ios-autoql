//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/02/22.
//

import SwiftUI
struct QLInputText: View {
    var label: String
    @Binding var value: String
    var body: some View{
        TextField(label, text: $value)
            .placeholder(when: value.isEmpty) {
                Text(label).foregroundColor(qlBorderColor)
            }
            .padding()
            .foregroundColor(qlColorWhite)
            .accentColor(Color.green)
            .background(
                AnyView(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(qlBackgroundColorPrimary)
                )
            ).onAppear {
                print(label)
            }
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
