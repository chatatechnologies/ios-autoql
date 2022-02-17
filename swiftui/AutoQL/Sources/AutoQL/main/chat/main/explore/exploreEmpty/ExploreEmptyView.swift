//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/02/22.
//

import SwiftUI
struct ExploreEmptyView: View {
    var body: some View{
        QLText(label: """
            Discover what you can ask by entering a topic in the search bar above.

            Simply click on any of the returned options to run the query in Data Messenger.
        """, multiAligment: .center)
    }
}
