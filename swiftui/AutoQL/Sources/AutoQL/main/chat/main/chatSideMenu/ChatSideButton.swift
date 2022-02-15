//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI
struct ChatSideButton: View {
    var label: String
    var type: ChatSideMenuType
    @Binding var mainType: ChatSideMenuType
    var body: some View{
        Button(label){
            mainType = type
        }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(
                type == mainType
                ? qlBackgroundColorSecondary
                : qlAccentColor
            )
    }
}
