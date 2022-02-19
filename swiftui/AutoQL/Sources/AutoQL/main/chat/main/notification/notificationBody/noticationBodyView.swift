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
                    notificationEmptyView()
                    
                } else {
                    NotificationListView()
                }
            }
        }
    }
}
