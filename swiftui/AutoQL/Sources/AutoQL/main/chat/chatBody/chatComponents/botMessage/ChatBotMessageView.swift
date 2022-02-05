//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBotMessageView: View {
    var label: String
    var position: Int
    var onClick: (_ position : Int) -> Void
    @State var buttons: [ChatToolbarModel] = [
        ChatToolbarModel(image: "T")
    ]
    var body: some View {
        HStack{
            QLText(label: label)
                .background(
                    AnyView(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(qlBackgroundColorPrimary)
                    )
                )
                .overlay(
                    ChatToolbarOptions(
                        onClick: remove,
                        buttons: buttons
                    ), alignment: .topTrailing
                )
                
            Spacer()
        }
        .onAppear(perform: {
            loadButtons()
        })
        .padding(
            EdgeInsets(
                top: 40,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
        )
    }
    func loadButtons(){
        buttons.append(ChatToolbarModel(image: "D"))
        print("new")
    }
    func remove(){
        onClick(position)
    }
}
struct ChatBotMessageModel: Hashable{
    var label: String
}
