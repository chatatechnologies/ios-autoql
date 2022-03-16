//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 03/02/22.
//

import SwiftUI

struct TopicSubView: View {
    @Binding var value: String
    @Binding var isLvl2: Bool
    var item: TopicModel
    var onClick: () -> Void
    var body: some View {
        HStack{
            VStack{
                Button {
                    isLvl2 = false
                } label: {
                    ImagePath(
                        name: "icArrowRight",
                        size: 20,
                        tintColor: true
                    ).rotationEffect(.degrees(-180))
                }
                Spacer()
            }
            VStack{
                HStack{
                    QLText(label: self.item.topic, padding: 0)
                    Spacer()
                }.onTapGesture {
                    isLvl2 = false
                }
                List{
                    ForEach(self.item.queries, id: \.self){
                        qbOption in
                        TopicItemView(
                            label: qbOption,
                            isSecondLevel: true,
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
