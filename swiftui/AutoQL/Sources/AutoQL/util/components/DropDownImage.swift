//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 07/02/22.
//

import SwiftUI

struct DropDownImage: View {
    var dropDownList: [ChatToolbarSubOptionModel]
    var image: String
    var onClick: (_ type: ChatToolbarSubOptionType) -> Void
    var body: some View{
        Menu {
            ForEach(dropDownList, id: \.self){ item in
                Button(item.label) {
                    onClick(item.typeFunction)
                }
            }
        } label:{
            ImagePath(name: image, size: 30)
        }
    }
}
