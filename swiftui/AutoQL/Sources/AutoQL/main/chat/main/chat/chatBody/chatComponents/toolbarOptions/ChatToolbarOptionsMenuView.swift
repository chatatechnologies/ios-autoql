//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 03/02/22.
//

import SwiftUI

struct ChatToolbarOptions: View {
    var side: sideType = .right
    var onClick: (_ typeFunction : ChatToolItemType) -> Void
    var onClickMenuAction: (_ typeFunction : ChatToolbarSubOptionType) -> Void
    @State var buttons: [ChatToolbarModel] = []
    var body: some View {
        HStack {
            HStack{
                ForEach(0..<buttons.count){
                    index in
                    Button{
                        onClick(buttons[index].typeFunction)
                    } label: {
                        ChatToolBatItemView(
                            type: buttons[index].typeFunction,
                            image: buttons[index].image,
                            onClickMenuAction: onClickMenuAction
                        )
                    }
                }
            }
            .padding(8)
        }
        .background(
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .fill(qlBackgroundColorPrimary)
                    .shadow(color: qlBorderColor, radius: 2)
            )
        ).padding(
            EdgeInsets(
                top: -36,
                leading: 0,
                bottom: 0,
                trailing: side == .left ? -60 : 0
            )
        )
    }
}
enum sideType {
    case left, right
}
