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
        MainChatViewController(showingChat: $showingChat)
    }
}
