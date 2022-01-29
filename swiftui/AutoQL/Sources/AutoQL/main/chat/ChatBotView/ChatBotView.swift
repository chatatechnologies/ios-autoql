//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBotView: View {
    var body: some View {
        ScrollView {
            VStack{
                ForEach(bodyMSG, id:\.self) {
                    bod in
                    switch(bod.type){
                    case .usermessage:
                        ChatBotMessageView(label: bod.label)
                    case .botmessage:
                        ChatUserMessageView(label: bod.label)
                    }
                }
            }
        }
    }
}

