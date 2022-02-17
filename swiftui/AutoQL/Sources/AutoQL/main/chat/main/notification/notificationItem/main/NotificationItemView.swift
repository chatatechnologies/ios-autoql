//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/02/22.
//

import SwiftUI

struct NotificationItemView: View{
    var data: NotificationModel
    var body: some View{
        VStack{
            DisclosureGroup(
                content: {
                    VStack{
                        Divider()
                        QLText(label: data.query)
                        Divider()
                        NotificationContentView(data: data.content)
                    }
                    .background(qlBackgroundColorPrimary)
                },
                label: {
                    ZStack{
                        VStack{
                            HStack{
                                QLText(label: data.name, padding:4)
                                Spacer()
                            }
                            HStack{
                                QLText(label: data.details, padding:4)
                                Spacer()
                            }
                            HStack{
                                QLText(label: data.date, padding:4)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            )
            .background(qlBackgroundColorPrimary)
            .padding()
            Spacer()
        }
    }
}
