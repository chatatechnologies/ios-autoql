//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 03/02/22.
//

import SwiftUI

struct ChatSubQueryBuilder: View {
    @Binding var value: String
    @Binding var isLvl2: Bool
    var qbOptionsLvl2: [String] = ["Total sales last month", "Top 5 customers by sales this year"]
    var onClick: () -> Void
    var body: some View {
        HStack{
            VStack{
                Button("B") {
                    isLvl2 = false
                }
                Spacer()
            }
            VStack{
                HStack{
                    QLText(label: "Items", padding: 4)
                    Spacer()
                }
                List{
                    ForEach(qbOptionsLvl2, id: \.self){
                        qbOption in
                        QueryBuilderItemView(
                            label: qbOption,
                            onClick: onClick,
                            value: $value
                        )
                    }
                }
                .frame(height:90)
                .listStyle(PlainListStyle())
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableView.appearance().bounces = false
                }
                Spacer()
            }
        }.padding()
    }
}
