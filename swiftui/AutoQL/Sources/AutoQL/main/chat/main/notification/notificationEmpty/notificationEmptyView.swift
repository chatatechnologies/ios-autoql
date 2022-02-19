//
//  File.swift
//  
//
//  Created by Vicente Rincon on 18/02/22.
//

import SwiftUI
struct notificationEmptyView : View{
    var body: some View{
        VStack{
            ImagePath(name: "icDefaultNotification", size: 150)
            QLText(label: "No notifications yet.", padding: 4)
            QLText(label: "Stay tuned", padding: 4)
            Spacer()
        }
    }
}
