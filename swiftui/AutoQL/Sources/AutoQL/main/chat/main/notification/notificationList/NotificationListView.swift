//
//  File.swift
//  
//
//  Created by Vicente Rincon on 15/02/22.
//
import SwiftUI
struct NotificationListView: View {
    let notifications = getNotifications()
    var body: some View {
        ScrollView{
            VStack{
                ForEach(getNotifications().indices, id: \.self){
                    index in
                    NotificationItemView(data: notifications[index])
                }
                Spacer()
            }
        }
    }
}
