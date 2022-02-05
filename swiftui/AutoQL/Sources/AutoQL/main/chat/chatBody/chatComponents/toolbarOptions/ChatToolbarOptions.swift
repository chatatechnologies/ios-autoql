//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 03/02/22.
//

import SwiftUI

struct ChatToolbarOptions: View {
    var onClick: () -> Void
    @State var buttons: [ChatToolbarModel] = []
    var body: some View {
        HStack {
            HStack{
                ForEach(0..<buttons.count){
                    index in
                    Button{
                        print("funca")
                    } label: {
                        Text(buttons[index].image)
                    }
                }
                /*Button {
                    print("Report")
                } label: {
                    Text("R")
                }*/

                /*Button(action: onClick) {
                    Text("D")
                }*/
                /*Button {
                    print("points")
                } label: {
                    Text("P")
                }*/
            }
            .padding(8)
        }
        .background(
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .shadow(color: qlBorderColor, radius: 2)
            )
        )
        .padding(
            EdgeInsets(
                top: -16,
                leading: 0,
                bottom: 0,
                trailing: -16
            )
        )
    }
}
