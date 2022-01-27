//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBotView: View {
    var body: some View {
        List {
            ChatIntroMessageView()
            ChatIntroMessageView()
            ChatIntroMessageView()
            ChatIntroMessageView()
        }.padding(0)
        .onAppear {
            //UITableView.appearance().sp
        }
    }
}

