//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/02/22.
//

import SwiftUI
struct NotificationContentView: View {
    var data: NotificationContentModel = NotificationContentModel()
    var body: some View{
        HStack{
            Group {
                if data.typeContent == .webview {
                    WebViewComponent(WbString: data.content)
                }
                else if data.typeContent == .botresponseText{
                    QLText(label: data.content)
                }
            }
        }
    }
}
