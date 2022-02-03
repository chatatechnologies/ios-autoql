//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

struct ChatQueryBuilder: View {
    var body: some View {
        HStack{
            VStack{
                QLText(label: "Some things you can ask me:")
                List{
                    QLText(label: "Sales", padding: 0)
                    QLText(label: "Items", padding: 0)
                    QLText(label: "Expenses", padding: 0)
                    QLText(label: "Purchase Orders", padding: 0)
                }
                .listStyle(PlainListStyle())
                .frame(height:150)
                QLText(label: "Use  Explore Queries to further explore the possibilities.")
            }.layoutPriority(1)
            Spacer()
        }
        .background(
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .fill(qlBackgroundColorPrimary)
            )
        )
        .padding(8)
    }
}
struct QueryBuilderItemView: View{
    var body: some View{
        HStack{
            QLText(label: "Sales", padding: 0)
            Spacer()
            Button {
                print("Into")
            } label: {
                Text("N")
            }

        }
    }
}
