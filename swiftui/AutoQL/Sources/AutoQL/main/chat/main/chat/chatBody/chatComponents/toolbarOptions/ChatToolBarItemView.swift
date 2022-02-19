//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 07/02/22.
//

import SwiftUI
struct ChatToolBatItemView : View  {
    var type: ChatToolItemType
    var image: String
    var onClickMenuAction: (_ typeFunction : ChatToolbarSubOptionType) -> Void
    var body: some View {
        Group {
            switch type {
            case .delete: ImagePath(name: image, size:30)
            case .report: DropDownImage(
                dropDownList: [
                    ChatToolbarSubOptionModel(
                        label: "Other...",
                        typeFunction: .other
                    ),
                    ChatToolbarSubOptionModel(
                        label: "The data is incomplete",
                        typeFunction: .incomplete
                    ),
                    ChatToolbarSubOptionModel(
                        label: "The data is incorrect",
                        typeFunction: .incorrect
                    )
                ],
                image: image,
                onClick: actionOption
            )
            case .more: DropDownImage(
                dropDownList: [
                    ChatToolbarSubOptionModel(
                        label: "View generated SQL",
                        typeFunction: .viewsql
                    )
                ],
                image: image,
                onClick: actionOption
            )
            }
        }
    }
    func actionOption(_ type: ChatToolbarSubOptionType){
        onClickMenuAction(type)
    }
}
