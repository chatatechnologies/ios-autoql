//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI

struct ButtonAutoQL: View {
    @Binding var showingChat: Bool
    var body: some View{
        ZStack{
            HStack{
                Button( action: openChat){
                    HStack{
                        ImagePath(name: "btnChata")
                    }.frame(width: 60, height: 60)
                        .background(qlAccentColor)
                        .clipShape(
                            Circle()
                        )
                }
            }
        }
    }
    func openChat(){
        print("Open Chat")
        self.showingChat.toggle()
    }
}
