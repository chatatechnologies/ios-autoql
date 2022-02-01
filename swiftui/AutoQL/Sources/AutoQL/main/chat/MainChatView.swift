//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct MainChatView: View {
    @State var valueInput = ""
    @State var allComponents: [ChatComponent] = []
    var body: some View {
        VStack{
            ChatBarView()
            ChatBodyView(allComponents: $allComponents)
            ChatBarBottomView(
                value: $valueInput,
                allComponents: $allComponents
            )
            Spacer()
        }
    }
}
