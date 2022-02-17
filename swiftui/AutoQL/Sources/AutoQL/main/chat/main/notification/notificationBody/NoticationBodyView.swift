//
//  File.swift
//  
//
//  Created by Vicente Rincon on 15/02/22.
//

import SwiftUI
struct NotificationBodyView: View{
    var isEmpty = false
    var body: some View {
        HStack{
            Group {
                if isEmpty {
                    VStack{
                        ImagePath(name: "btnChata", size: 150)
                        QLText(label: "No notifications yet.", padding: 4)
                        QLText(label: "Stay tuned", padding: 4)
                        Spacer()
                    }
                    
                } else {
                    NotificationListView()
                }
            }
        }
    }
}
