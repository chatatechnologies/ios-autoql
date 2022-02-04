//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

struct ChatQueryBuilder: View {
    @Binding var value: String
    @State private var changeLvl2 = false
    var onClick: () -> Void
    var qbOptionsLvl1: [String] = ["Sales", "Items", "Expenses", "Purchase Orders"]
    var body: some View {
        HStack{
            VStack{
                HStack{
                    QLText(label: "Some things you can ask me:")
                    Spacer()
                }
                Group {
                    if !changeLvl2{
                        getQueryBuilderLvl1()
                    }
                    else {
                        ChatSubQueryBuilder(
                            value: $value,
                            isLvl2: $changeLvl2,
                            onClick: onClick
                        )
                    }
                }
                HStack{
                    QLText(label: "Use  Explore Queries to further explore the possibilities.")
                    Spacer()
                }
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
    func selectOptionQB1(){
        print("go lvl 2")
        changeLvl2 = true
    }
    @ViewBuilder
    func getQueryBuilderLvl1() -> some View {
        List{
            ForEach(qbOptionsLvl1, id: \.self){
                qbOption in
                QueryBuilderItemView(
                    label: qbOption,
                    onClick: selectOptionQB1,
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
    }
}
