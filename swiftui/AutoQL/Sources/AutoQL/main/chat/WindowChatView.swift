//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI

struct WindowChatView: View{
    @Binding var showingChat: Bool
    var body: some View{
        ZStack{
            GeometryReader { p in
                HStack(spacing: 0){
                    HStack{}
                    .frame(width: 24, height: abs(p.size.height))
                    .background(.black.opacity(0.3))
                    .onTapGesture {
                        self.showingChat.toggle()
                    }.padding(0)
                    MainChatView(showingChat: $showingChat)
                        .frame(width: abs(p.size.width - 24 ), height: abs(p.size.height), alignment: .center)
                        .padding(0)
                        .background(qlBackgroundColorSecondary)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
