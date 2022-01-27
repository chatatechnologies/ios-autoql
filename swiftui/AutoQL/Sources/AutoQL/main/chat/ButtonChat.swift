//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI

struct ButtonAutoQL: View {
    @Binding var showingChat: Bool
    var colors = Colors()
    var body: some View{
        ZStack{
            Button( action: openChat){
                HStack{
                    ImagePath(name: "btnChata")
                }.frame(width: 60, height: 60)
                    .background(colors.accentColor)
                    .clipShape(
                        Circle()
                    )
            }
        }
    }
    func openChat(){
        print("Open Chat")
        self.showingChat.toggle()
    }
}
