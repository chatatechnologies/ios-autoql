//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

struct ChatQueryBuilder: View {
    @Binding var value: String
    var onClick: () -> Void
    var qbOptionsLvl1: [String] = ["Sales", "Items", "Expenses", "Purchase Orders"]
    var body: some View {
        HStack{
            VStack{
                QLText(label: "Some things you can ask me:")
                List{
                    ForEach(qbOptionsLvl1, id: \.self){
                        qbOption in
                        QueryBuilderItemView(
                            label: qbOption,
                            onClick: onClick,
                            value: $value
                        )
                    }
                }
                .frame(height:180)
                .listStyle(PlainListStyle())
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableView.appearance().bounces = false
                }
                QLText(label: "Use  Explore Queries to further explore the possibilities.", padding: 8)
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
