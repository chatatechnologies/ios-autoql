//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 08/02/22.
//

import SwiftUI

struct MainChatViewController: View {
    @State var showingChat: Bool = false
    @State private var isPresented: Bool = false
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
                    MainChatView(
                        showingChat: $showingChat,
                        isPopUp: $isPresented
                    )
                    .frame(width: abs(p.size.width - 24 ), height: abs(p.size.height), alignment: .center)
                    .padding(0)
                    .background(qlBackgroundColorSecondary)
                }
            }
        }
        .customPopupView(isPresented: $isPresented, popupView: { popupView(isPresented: $isPresented) })
        .edgesIgnoringSafeArea(.all)
        
    }
}
