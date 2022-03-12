//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

struct TopicView: View {
    @Binding var value: String
    @StateObject var viewModel = TopicViewModel()
    var onClick: () -> Void
    var body: some View {
        HStack{
            VStack{
                HStack{
                    QLText(label: "Some things you can ask me:")
                    Spacer()
                }
                Group {
                    if !viewModel.changeLvl2{
                        TopicsLvl1(
                            viewModel: viewModel,
                            value: $value)
                    }
                    else {
                        TopicSubView(
                            value: $value,
                            isLvl2: $viewModel.changeLvl2,
                            item: TopicService.instance.topics[viewModel.indexSelect],
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
}
struct TopicsLvl1: View{
    var viewModel = TopicViewModel()
    @Binding var value: String
    var body: some View{
        List{
            ForEach(viewModel.qbOptionsLvl1.indices, id: \.self){
                index in
                TopicItemView(
                    label: viewModel.qbOptionsLvl1[index],
                    onClick: {
                        viewModel.selectOptionQB1(position: index)
                    },
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
