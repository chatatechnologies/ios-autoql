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
                            .frame(width: 32.0, height: 32.0)
                    }.frame(width: 40, height: 40)
                        .background(qlAccentColor)
                        .clipShape(
                            Circle()
                            
                        ).shadow(color: qlBorderColor, radius: 2)
                }
            }
        }
    }
    func openChat(){
        print("Open Chat")
        self.showingChat.toggle()
    }
}
