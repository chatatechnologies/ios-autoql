//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct MainChatView: View {
    @State var valueInput = ""
    var body: some View {
        VStack{
            ChatBarView()
            ChatBotView()
            InputView(value: $valueInput)
            Spacer()
        }
    }
}
