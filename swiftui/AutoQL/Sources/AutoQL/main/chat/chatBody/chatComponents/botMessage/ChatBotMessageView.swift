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
        ChatToolbarModel(image: "R", typeFunction: .report),
        ChatToolbarModel(image: "D", typeFunction: .delete),
        ChatToolbarModel(image: "P", typeFunction: .more)
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
                        onClick: toolbarAction,
                        buttons: buttons
                    ), alignment: .topTrailing
                )
                
            Spacer()
        }
        .padding(
            EdgeInsets(
                top: 40,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
        )
    }
    func toolbarAction(_ typeFunction: ChatToolItemType){
        switch(typeFunction){
        case .delete: onClick(position)
        case .more: print("more options")
        case .report: print("Report")
        }
    }
}
struct ChatBotMessageModel: Hashable{
    var label: String
}
