//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/02/22.
//

import SwiftUI
struct ExploreItemView: View {
    var label: String
    var action: (_ query: String) -> Void
    var body: some View{
        HStack{
            Spacer()
            QLButtonList(label: label, onClick: selectedQuery)
            Spacer()
        }
        .listRowBackground(qlBackgroundColorSecondary)
        .background(qlBackgroundColorSecondary)
    }
    func selectedQuery(){
        action(label)
    }
}
