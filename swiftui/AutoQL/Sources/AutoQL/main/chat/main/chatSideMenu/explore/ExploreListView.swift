//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/02/22.
//

import SwiftUI
struct ExploreListView: View{
    @Binding var sendQuery: String
    @Binding var sendRequest: Bool
    var body: some View{
        List{
            ExploreItemView(label: "All sales last year", action: action)
            ExploreItemView(label: "All sales over", action: action)
            ExploreItemView(label: "All sales under", action: action)
        }
        .listStyle(PlainListStyle())
        .background(qlBackgroundColorSecondary)
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().bounces = false
        }
    }
    func action(_ query: String) {
        sendQuery = query
        sendRequest = true
    }
}
