//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI
struct chatSideMenuView: View{
    @Binding var optSelected: ChatSideMenuType
    var body: some View {
        HStack{
            VStack{
                VStack(spacing:0){
                    ChatSideButton(
                        image: "icSideChat",
                        type: ChatSideMenuType.chat,
                        mainType: $optSelected
                    )
                    ChatSideButton(
                        image: "icSideExplore",
                        type: ChatSideMenuType.explore,
                        mainType: $optSelected
                    )
                    ChatSideButton(
                        image: "icSideNotification",
                        type: ChatSideMenuType.notification,
                        mainType: $optSelected
                    )
                }
                .frame(maxWidth: .infinity)
                .background(qlBackgroundColorSecondary)
                .padding(.top, 100)
                Spacer()
            }
            
        }
    }
}
enum ChatSideMenuType {
    case chat, explore, notification
}
