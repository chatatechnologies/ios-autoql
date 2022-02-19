//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI
struct ChatSideButton: View {
    var image: String
    var type: ChatSideMenuType
    @Binding var mainType: ChatSideMenuType
    var body: some View{
        Button {
            mainType = type
        } label: {
            ImagePath(name: image, size: 30, tintColor: type == mainType)
        }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(
                type == mainType
                ? qlBackgroundColorSecondary
                : qlAccentColor
            )
    }
}
