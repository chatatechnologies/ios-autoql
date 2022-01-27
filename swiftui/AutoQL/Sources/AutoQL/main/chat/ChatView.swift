//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI

struct ChatView: View{
    @Binding var showingChat: Bool
    var body: some View{
        ZStack{
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack{
                Text("TEST")
            }.frame(width: 300, height: 300, alignment: .center)
                .background(.black)
        }.onTapGesture {
            self.showingChat.toggle()
        }
    }
}
