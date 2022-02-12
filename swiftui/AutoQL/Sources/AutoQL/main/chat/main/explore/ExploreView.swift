//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/02/22.
//

import SwiftUI

struct ExploreView: View {
    @Binding var showingChat: Bool
    @State var valueInput = ""
    var body: some View {
        VStack{
            ChatTopBarView(
                showingChat: $showingChat,
                label: "Explore Queries"
            ){}
            Spacer()
        }
    }
}
